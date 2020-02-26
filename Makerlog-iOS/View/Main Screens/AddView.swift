//
//  AddView.swift
//  iOS
//
//  Created by Veit Progl on 14.02.20.
//  Copyright © 2020 Veit Progl. All rights reserved.
//

import Foundation
import SwiftUI
import SwiftUIX

struct AddView: View {
	//swiftlint:disable empty_parentheses_with_trailing_closure multiple_closures_with_trailing_closure

	@EnvironmentObject var tabScreenData: TabScreenData
	@EnvironmentObject var login: LoginData

	var types = ["log", "discussion"]
	@State private var selectedType = 0

	var body: some View {
		NavigationView() {
			VStack() {
				Picker(selection: $selectedType, label: Text("Types")) {
					ForEach(0 ..< types.count) {
						Text(self.types[$0]).tag($0)
					}
				}.pickerStyle(SegmentedPickerStyle())

				if selectedType == 0 {
					AddLogView()
				} else if selectedType == 1 {
					AddDiscussionView()
				} else {
					Spacer()
				}
			}
			.padding([.leading, .trailing], 20)
			.padding([.bottom], 10)
		}
	}
}
