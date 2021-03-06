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

//swiftlint:disable multiple_closures_with_trailing_closure
struct AddLogView: View {
    @ObservedObject var data: AddLogData
	@State private var selectedType = 0
    @State var log: Log?
    @State var isEdit = false

	var types = [AddTyps(name: "done", title: "What have you done today ?"),
				 AddTyps(name: "to do", title: "What will you do ?"),
				 AddTyps(name: "in work", title: "What are you working on ?")]

	// swiftlint:disable empty_parentheses_with_trailing_closure
    var body: some View {
		VStack(alignment: .leading) {
//            Text("\(selectedType)")
			Text("Log State:").font(Font.headline)
			Picker(selection: $selectedType, label: Text("Log State")) {
				ForEach(0 ..< types.count) {
					Text(self.types[$0].name).tag($0)
				}
			}.pickerStyle(SegmentedPickerStyle())

			GeometryReader() { geometry in
				TextView(self.types[self.selectedType].title, text: self.$data.text)
					.padding(5)
            }.frame(height: 100)
            Divider()
            GeometryReader() { geometry in
                TextView("Add a description", text: self.$data.description)
                    .padding(5)
                    .keyboardObserving()
            }
            

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
                    if isEdit {
                        Button(action: {
                            self.update()
                        }) {
                            Text("Edit")
                        }
                    } else {
                        Button(action: {
                            self.save()
                        }) {
                            Text("Send")
                        }
                    }
				}
			)
    }

	func save() {
        if self.selectedType == 0 {
            self.data.isDone = true
            self.data.isProgress = false
        } else if self.selectedType == 1 {
            self.data.isDone = false
            self.data.isProgress = false
        } else if self.selectedType == 2 {
            self.data.isDone = false
            self.data.isProgress = true
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
    
    func update() {
        self.data.taskID = self.log?.id ?? 0
        
        if self.selectedType == 0 {
            self.data.isDone = true
            self.data.isProgress = false
        } else if self.selectedType == 1 {
            self.data.isDone = false
            self.data.isProgress = false
        } else if self.selectedType == 2 {
            self.data.isDone = false
            self.data.isProgress = true
        }

        self.data.updateLog()
//        self.data.text = ""
//        self.data.isDone = false
//        self.data.isProgress = false
        UIApplication.shared.windows.first?.endEditing(true)
    }
}

struct AddLogView_Previews: PreviewProvider {
    static var previews: some View {
        AddLogView(data: AddLogData())
    }
}
