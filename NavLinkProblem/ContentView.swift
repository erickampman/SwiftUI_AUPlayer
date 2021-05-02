//
//  ContentView.swift
//  NavLinkProblem
//
//  Created by Eric Kampman on 5/2/21.
//

import SwiftUI

struct ContentView: View {
	@ObservedObject var auInfo: AUInfo
    var body: some View {
		NavigationView {
			List {
				ForEach(auInfo.effects.indices, id: \.self) { index in
					NavigationLink(destination: DetailView(data: .constant(auInfo.effects[index])),
					   label: {
						Text(auInfo.effects[index].auDetail)
						}
					)
				}
			}
		}
	}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
		ContentView(auInfo: AUInfo())
    }
}

