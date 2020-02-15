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
    var types = ["log", "discussion", "milestone", "project"]
    @State private var selectedType = 0

	var body: some View {
		NavigationView() {
			VStack() {

				if selectedType == 0 {
					AddLogView()
				} else if selectedType == 1 {
					AddDiscussionView()
				} else {
					Spacer()
				}

				Picker(selection: $selectedType, label: Text("Types")) {
					ForEach(0 ..< types.count) {
						Text(self.types[$0]).tag($0)
					}
				}.pickerStyle(SegmentedPickerStyle())
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

			TextField("Add discussion title", text: self.$data.title)
				.textFieldStyle(RoundedBorderTextFieldStyle())

			TextView("Add discussion text", text: self.$data.text)
				.padding(5)
				.addBorder(Color.gray, width: 1, cornerRadius: 7)
			Spacer()

			HStack() {
				Text("Done")
					.font(Font.system(size: 18))
					.bold()
			}
			.padding(4)
			.padding([.leading, .trailing], 10)
			.frame(minWidth: 0, maxWidth: .infinity, minHeight: 50)
			.addBorder(Color.blue, width: 2, cornerRadius: 13)
			.foregroundColor(.blue)
			.onTapGesture {
				self.data.createNewDiscussion()
				self.data.text = ""
				self.data.title = ""
				UIApplication.shared.windows.first?.endEditing(true)
			}
		}.navigationBarTitle("Add a Discussion")
    }
}
