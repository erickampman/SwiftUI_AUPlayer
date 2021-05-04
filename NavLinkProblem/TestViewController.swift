//
//  TestViewController.swift
//  NavLinkProblem
//
//  Created by Eric Kampman on 5/2/21.
//

import Cocoa

class TestViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
		floatTextField.floatValue = floatValue
		boolCheckBox.intValue = boolValue ? 1 : 0
    }
	
	@IBOutlet weak var floatTextField: NSTextField!
	@IBOutlet weak var boolCheckBox: NSButton!
	
	@IBAction func floatAction(_ sender: NSTextField) {
		floatValue = sender.floatValue
	}
	@IBAction func boolAction(_ sender: NSButton) {
		boolValue = sender.intValue != 0
	}
	
	var floatValue = Float(0)
	var boolValue = true
}
