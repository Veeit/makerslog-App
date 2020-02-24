//
//  AddLogView.swift
//  Makerlog
//
//  Created by Veit Progl on 04.02.20.
//  Copyright © 2020 Veit Progl. All rights reserved.
//

import SwiftUI
import SwiftUIX

struct AddTyps {
	var name: String
	var title: String
}

struct AddLogView: View {
	@ObservedObject var data = AddLogData()
	@State private var selectedType = 0

	var types = [AddTyps(name: "done", title: "What have you done today ?"),
				 AddTyps(name: "to do", title: "What will you do ?"),
				 AddTyps(name: "in work", title: "What are you working on ?")]

	// swiftlint:disable empty_parentheses_with_trailing_closure
    var body: some View {
		VStack(alignment: .leading) {

			Text("Log State:").font(Font.headline)
			Picker(selection: $selectedType, label: Text("Log State")) {
				ForEach(0 ..< types.count) {
					Text(self.types[$0].name).tag($0)
				}
			}.pickerStyle(SegmentedPickerStyle())

			TextView(self.types[selectedType].title, text: self.$data.text)
				.padding(5)

		}.navigationBarTitle("Log your task")
			.navigationBarItems(leading:
				HStack() {
					Button(action: {
						self.cancel()
					}) {
						Text("Cancel")
					}
				}, trailing:
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
		switch self.selectedType {
		case 3:
			self.data.isDone = false
			self.data.isProgress = true
		case 2:
			self.data.isDone = false
			self.data.isProgress = false
		default:
			self.data.isDone = true
			self.data.isProgress = false
		}

		self.data.createNewLog()
		self.data.text = ""
		self.data.isDone = false
		self.data.isProgress = false
		UIApplication.shared.windows.first?.endEditing(true)
	}
	
	func cancel() {
		UIApplication.shared.windows.first?.endEditing(true)
		self.data.text = ""
		self.data.isDone = false
		self.data.isProgress = false
	}
}

struct AddLogView_Previews: PreviewProvider {
    static var previews: some View {
        AddLogView()
    }
}
