//
//  AUInfo.swift
//  NavLinkProblem
//
//  Created by Eric Kampman on 5/2/21.
//

import Foundation
import SwiftUI
import AudioToolbox
import AVFAudio

struct AudioUnitData: Hashable {
	let auDesc: AudioComponentDescription
	
	static func == (lhs: AudioUnitData, rhs: AudioUnitData) -> Bool {
		lhs.auDesc.componentManufacturer == rhs.auDesc.componentManufacturer &&
		lhs.auDesc.componentType == rhs.auDesc.componentType &&
		lhs.auDesc.componentSubType == rhs.auDesc.componentSubType
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
	
	mutating func validate() -> AudioComponentValidationResult {
		if .unknown != auValidationResult {
			return auValidationResult
		}
		var result = AudioComponentValidationResult(rawValue: 0)!
		var desc = auDesc
		let component = AudioComponentFindNext(nil, &desc)
		let status = AudioComponentValidate(component!, nil, &result);
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

//	lazy var auDetail: String = {
//		let comp = AVAudioUnitComponentManager.shared().components(matching: auDesc)
//		if comp.isEmpty {
//			return ""
//		}
//		let n = comp[0].name
//		let mfg = comp[0].manufacturerName
//		return String(format: "%@: %@", mfg, n)
//	}()
	var auDetail = String()
}

class AUInfo: ObservableObject {
	@Published var effects = [AudioUnitData]()

	init() {
		var desc = AudioComponentDescription(componentType: 0, componentSubType: 0, componentManufacturer: 0, componentFlags: 0, componentFlagsMask: 0)
		
		let auCount = AudioComponentCount(&desc)
		Swift.print("Count: \(auCount)")
		
		let comps = AVAudioUnitComponentManager.shared().components(matching: desc)
		
		for c in comps {
			let desc = c.audioComponentDescription
			
			if "aufx".osType() == desc.componentType {
				let n = c.name
				let mfg = c.manufacturerName
				let detail = String(format: "%@: %@", mfg, n)
				let data = AudioUnitData(auDesc: desc, auDetail: detail)
				effects.append(data)
			}
		}
	}
}

