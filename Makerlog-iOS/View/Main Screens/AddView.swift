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
    @State var log: Log?

    @ObservedObject var data = AddLogData()

	var types = ["log", "discussion"]
	@State private var selectedType = 0
    @State private var isEdit = false

	var body: some View {
		NavigationView() {
			VStack() {
//				Picker(selection: $selectedType, label: Text("Types")) {
//					ForEach(0 ..< types.count) {
//						Text(self.types[$0]).tag($0)
//					}
//				}.pickerStyle(SegmentedPickerStyle())

//				if selectedType == 0 {
                AddLogView(data: data, log: log, isEdit: isEdit)
//				} else if selectedType == 1 {
//					AddDiscussionView()
//				} else {
//					Spacer()
//				}
			}
			.padding([.leading, .trailing], 20)
			.padding([.bottom], 10)
		}.navigationViewStyle(StackNavigationViewStyle())
            .onAppear(perform: {
                if self.log != nil {
                    self.isEdit = true
                    self.data.text = self.log?.content ?? ""
//                    self.data.isDone = self.log?.done ?? false
//                    self.data.isProgress = self.log?.inProgress ?? false
                    self.data.description = self.log?.description ?? ""
                }
            })
	}
}
