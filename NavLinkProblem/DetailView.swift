//
//  DetailView.swift
//  NavLinkProblem
//
//  Created by Eric Kampman on 5/2/21.
//

import SwiftUI

struct DetailView: View {
	@ObservedObject var auMgr: AUMgr
	@State private var showComponentView = false
	@State private var auViewController = NSViewController?.none
	@State private var prevIndex = Int?.none
	@State private var isPlaying = false

	var index: Int
	var body: some View {
		VStack {
			Text(auMgr.components[index].auName)
				.font(.largeTitle)
			HStack {
				Text("Type: ").bold()
				Text(auMgr.components[index].auType)
			}
			HStack {
				Text("Subtype: ").bold()
				Text(auMgr.components[index].auSubType)
			}
			HStack {
				Text("Manufacturer: ").bold()
				Text(auMgr.components[index].auManufacturer)
			}
			HStack {
				Button( "Validate",
				   action: { _ = auMgr.components[index].validate() })
				Text(auMgr.components[index].auValidationResultString)
			}
			HStack {
				Button("Show UI") {
					self.showComponentView = true
					if .none == prevIndex || prevIndex! != index {
//					if nil == auMgr.audioUnitViewController {
						auMgr.selectComponent(at: index) { _ in
							Swift.print("selectComponent completion")
						}
						auMgr.loadAudioUnitViewController { _ in
							Swift.print("loadAudioUnitViewController callback")
							
							// I don't think this will work since DetailView is a struct
//							auVC in self.auViewController = auVC
						}
						prevIndex = index
					}
				}
				.disabled(!auMgr.components[index].auComponent.hasCustomView)
				
			}
			if (showComponentView) {
				Button( isPlaying ? "Stop" : "Play",
				   action: {
					_ = auMgr.togglePlayback()
					isPlaying = !isPlaying
				   })

				ComponentViewControllerRepresentable(auMgr: auMgr, index: index)
			}
		}
	}
}
