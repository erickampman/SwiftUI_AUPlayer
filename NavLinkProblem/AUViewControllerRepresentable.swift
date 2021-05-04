//
//  AUViewControllerRepresentable.swift
//  NavLinkProblem
//
//  Created by Eric Kampman on 5/2/21.
//

import SwiftUI
import CoreAudioKit

/*
var providesUserInterface: Bool { get }

func supportedViewConfigurations(_ availableViewConfigurations: [AUAudioUnitViewConfiguration]) -> IndexSet

*/
struct AUViewControllerRepresentable: NSViewControllerRepresentable {
	func makeNSViewController(context: Context) -> AUViewController {
		return NSViewController() as! AUViewController
	}
	
	func updateNSViewController(_ nsViewController: AUViewController, context: Context) {
	}
	
	typealias NSViewControllerType = AUViewController
}
