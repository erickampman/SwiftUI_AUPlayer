//
//  NavLinkProblemApp.swift
//  NavLinkProblem
//
//  Created by Eric Kampman on 5/2/21.
//

import SwiftUI

@main
struct NavLinkProblemApp: App {
	var auInfo = AUInfo()
    var body: some Scene {
        WindowGroup {
			ContentView(auInfo: auInfo)
        }
    }
}
