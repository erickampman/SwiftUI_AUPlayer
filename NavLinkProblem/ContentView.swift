//
//  ContentView.swift
//  NavLinkProblem
//
//  Created by Eric Kampman on 5/2/21.
//

import SwiftUI

struct ContentView: View {
	@ObservedObject var auMgr: AUMgr
    var body: some View {
		NavigationView {
			List {
				ForEach(auMgr.components.indices, id: \.self) { index in
					NavigationLink(destination: DetailView(auMgr: auMgr,
														   index: index),
					   label: {
						Text(auMgr.components[index].auName)
						}
					)
				}
			}
		}
	}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
		ContentView(auMgr: AUMgr("aufx".osType()!))
    }
}

