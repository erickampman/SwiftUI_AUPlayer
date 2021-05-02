//
//  DetailView.swift
//  NavLinkProblem
//
//  Created by Eric Kampman on 5/2/21.
//

import SwiftUI

struct DetailView: View {
	@Binding var data: AudioUnitData
	var body: some View {
		VStack {
			Text($data.wrappedValue.auDetail)
				.font(.largeTitle)
			HStack {
				Button( "Validate",
				   action: { data.validate() })
				Text(data.auValidationResultString)
			}
		}
	}
}
