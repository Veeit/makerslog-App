//
//  AddDiscussionView.swift
//  iOS
//
//  Created by Veit Progl on 26.02.20.
//  Copyright © 2020 Veit Progl. All rights reserved.
//

import SwiftUI
import SwiftUIX

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
