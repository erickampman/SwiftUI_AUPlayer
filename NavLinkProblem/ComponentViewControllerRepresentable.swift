//
//  ComponentViewControllerRepresentable.swift
//  NavLinkProblem
//
//  Created by Eric Kampman on 5/2/21.
//

import SwiftUI

struct ComponentViewControllerRepresentable: NSViewControllerRepresentable {
	@ObservedObject var auMgr: AUMgr
	var index: Int
	
	class Coordinator: NSObject {
		// nothing yet
	}
	
	func makeCoordinator() -> Coordinator {
		Coordinator()
	}
	
	func makeNSViewController(context: Context) -> ComponentViewController {
		let controller = ComponentViewController()
		return controller
	}
		
	func updateNSViewController(_ nsViewController: ComponentViewController, context: Context)
	{
//		nsViewController.feedbackLabel.stringValue = auMgr.components[index].auName
		if let vc = auMgr.audioUnitViewController {
			nsViewController.presentUserInterface(vc.view, labelText: auMgr.components[index].auName)
		}

	}
	
	typealias NSViewControllerType = ComponentViewController
}
