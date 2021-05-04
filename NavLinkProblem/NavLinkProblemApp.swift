//
//  NavLinkProblemApp.swift
//  NavLinkProblem
//
//  Created by Eric Kampman on 5/2/21.
//

import SwiftUI

@main
struct NavLinkProblemApp: App {
//	var auInfo = AUInfo()
	var auMgr = AUMgr("aufx".osType()!)

	init() {
		auMgr.addComponents { _ in
			Swift.print("got components")
		}
	}
    var body: some Scene {
        WindowGroup {
			ContentView(auMgr: auMgr)
        }
    }
}
