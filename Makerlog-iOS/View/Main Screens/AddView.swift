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
//    var types = ["log", "discussion", "milestone", "project"]
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

struct AddDiscussionView: View {
	@ObservedObject var data = AddDiscussionData()

	// swiftlint:disable empty_parentheses_with_trailing_closure
    var body: some View {
		VStack(alignment: .leading) {
			Spacer()

			Text("Title:").font(Font.headline)
			TextField("Discuss what ?", text: self.$data.title)

			Text("Discussion:").font(Font.headline)
			TextView("Describe your discussion", text: self.$data.text)

			Spacer()
		}.navigationBarTitle("Add a Discussion")
		.navigationBarItems(
			leading:
			HStack() {
				Button(action: {
					self.cancel()
				}) {
					Text("Cancel")
				}
			},
			trailing:
			HStack() {
				Button(action: {
					self.save()
				}) {
					Text("Send")
				}
			}
		)
    }

	func save() {
		self.data.createNewDiscussion()
		self.data.text = ""
		self.data.title = ""
		UIApplication.shared.windows.first?.endEditing(true)
	}

	func cancel() {
		self.data.text = ""
		self.data.title = ""
		UIApplication.shared.windows.first?.endEditing(true)
	}
}
