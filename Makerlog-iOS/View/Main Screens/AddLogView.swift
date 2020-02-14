//
//  AddLogView.swift
//  Makerlog
//
//  Created by Veit Progl on 04.02.20.
//  Copyright © 2020 Veit Progl. All rights reserved.
//

import SwiftUI

struct AddLogView: View {
	@ObservedObject var data = AddLogData()

    var sports = ["Soccer", "Rugby", "Cricket", "Tennis"]

    @State private var selectedSport = 0
	// swiftlint:disable empty_parentheses_with_trailing_closure
    var body: some View {
		VStack(alignment: .leading) {
			Spacer()

			Picker(selection: $selectedSport, label: Text("Sport")) {
				ForEach(0 ..< sports.count) {
					Text(self.sports[$0]).tag($0)

				}
			}.pickerStyle(SegmentedPickerStyle())

			TextField("Add new log", text: self.$data.text)
				.textFieldStyle(RoundedBorderTextFieldStyle())
			HStack(spacing: 5) {
				Image(systemName: self.data.isDone ? "checkmark.square": "square").imageScale(.large)
				Text("is Done")
			}.onTapGesture {
				self.data.isDone.toggle()
			}

			HStack(spacing: 5) {
				Image(systemName: self.data.isProgress ? "checkmark.square": "square").imageScale(.large)
				Text("in Progress")
			}.onTapGesture {
				self.data.isProgress.toggle()
			}
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
				self.data.createNewLog()
				self.data.text = ""
				self.data.isDone = false
				self.data.isProgress = false
				UIApplication.shared.windows.first?.endEditing(true)
			}
		}.padding([.leading, .trailing], 20)
    }
}

struct AddLogView_Previews: PreviewProvider {
    static var previews: some View {
        AddLogView()
    }
}
