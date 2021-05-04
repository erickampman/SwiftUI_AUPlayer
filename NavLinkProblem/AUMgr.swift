//
//  AudioUnitManager.swift
//  NavLinkProblem
//
//  Created by Eric Kampman on 5/2/21.
//

import Foundation
import CoreAudioKit
import AVFoundation

// (Apple) An enum used to prevent exposing the Core Audio AudioComponentInstantiationOptions to the UI layer.
enum InstantiationType: Int {
	case inProcess
	case outOfProcess
}

struct Component: Hashable {
	let auComponent: AVAudioUnitComponent
	
	var auDesc: AudioComponentDescription {
		return auComponent.audioComponentDescription
	}
	
	func hash(into hasher: inout Hasher) {
		hasher.combine(auDesc.componentManufacturer)
		hasher.combine(auDesc.componentType)
		hasher.combine(auDesc.componentSubType)
	}
	
	var auManufacturer: String {
		return String.from(osType: auDesc.componentManufacturer)
	}
	var auType: String {
		return String.from(osType: auDesc.componentType)
	}
	var auSubType: String {
		return String.from(osType: auDesc.componentSubType)
	}
	var auName: String {
		return "\(auComponent.name) (\(auComponent.manufacturerName))"
	}

	mutating func validate() -> AudioComponentValidationResult {
		if .unknown != auValidationResult {
			return auValidationResult
		}
		var result = AudioComponentValidationResult(rawValue: 0)!
		let status = AudioComponentValidate(auComponent.audioComponent, nil, &result);
		if 0 == status {
			auValidationResult = result
		}
		return auValidationResult
	}
	var auValidationResult = AudioComponentValidationResult.unknown
	
	var auValidationResultString: String {
		switch auValidationResult {
		case .passed:
			return "Passed"
		case .failed:
			return "Failed"
		case .timedOut:
			return "Timed Out"
		case .unauthorizedError_Open:
			return "Unauthorized Error Open"
		case .unauthorizedError_Init:
			return "Unauthorized Error Init"
		case .unknown:
			fallthrough
		default:
			return "Unknown"
		}
	}

}

class AUMgr: ObservableObject {
	@Published var components = [Component]()
	@Published var audioUnit = AUAudioUnit?.none
	@Published var audioUnitViewController = NSViewController?.none {
		didSet {
			Swift.print("didSet audioUnitViewController")
		}
	}
	
	private let auType: OSType

	init(_ auType: OSType) {
		self.auType = auType
	}
		
	func addComponents(completion: @escaping ([Component]) -> Void) {
		// Reset the engine to remove any configured audio units.
		playEngine.reset()
		
		DispatchQueue.global(qos: .default).async {
			let desc = AudioComponentDescription(componentType: self.auType,
												 componentSubType: 0,
												 componentManufacturer: 0,
												 componentFlags: 0,
												 componentFlagsMask: 0)
			let components = AVAudioUnitComponentManager.shared().components(matching: desc)
			let wrapped = components.map { Component(auComponent: $0) }
			self.components = wrapped
			
			DispatchQueue.main.async {
				completion(wrapped)
			}
		}
	}
	
	#if targetEnvironment(macCatalyst)
	private let options = AudioComponentInstantiationOptions.loadOutOfProcess
	#else
	private var options = AudioComponentInstantiationOptions.loadOutOfProcess

	/// Determines how the audio unit is instantiated.
	@available(iOS, unavailable)
	var instantiationType = InstantiationType.outOfProcess {
		didSet {
			options = instantiationType == .inProcess ? .loadInProcess : .loadOutOfProcess
		}
	}
	#endif

	func selectComponent(at index: Int, completion: @escaping (Result<Bool, Error>) -> Void) {
		audioUnit = .none
		audioUnitViewController = .none
		
		let au = components[index].auComponent
		AVAudioUnit.instantiate(with: au.audioComponentDescription, options: options) { avAudioUnit, error in
			guard error == nil else {
				DispatchQueue.main.async {
					completion(.failure(error!))
				}
				return
			}
			self.audioUnit = avAudioUnit?.auAudioUnit
			self.playEngine.connect(avAudioUnit: avAudioUnit) {
				DispatchQueue.main.async {
					if let audioUnit = self.audioUnit {
						audioUnit.requestViewController { viewController in
							self.audioUnitViewController = viewController
						}
					}
					completion(.success(true))
				}
			}
			
			// TEMP FIXME
//			DispatchQueue.main.async {
//				if let audioUnit = self.audioUnit {
//					audioUnit.requestViewController { viewController in
//						DispatchQueue.main.async {
//							self.audioUnitViewController = viewController
//							completion(.success(true))
//						}
//					}
//				} else {
//					completion(.failure(error!))	// wrong FIXME
//				}
//
//				completion(.success(true))
//			}

		}
	}
	
	func loadAudioUnitViewController(completion: @escaping (NSViewController?) -> Void) {
		if let audioUnit = audioUnit {
			audioUnit.requestViewController { viewController in
				DispatchQueue.main.async {
					self.audioUnitViewController = viewController
					completion(viewController)
				}
			}
		} else {
			completion(nil)
		}
	}
	
	// MARK: Audio Transport

	@discardableResult
	func togglePlayback() -> Bool {
		return playEngine.togglePlay()
	}

	func stopPlayback() {
		playEngine.stopPlaying()
	}
	
	public func isPlaying() -> Bool {
		return playEngine.getIsPlaying()
	}

	private let playEngine = SimplePlayEngine()
}
