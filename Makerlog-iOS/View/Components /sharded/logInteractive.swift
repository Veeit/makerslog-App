//
//  logInteractive.swift
//  iOS
//
//  Created by Veit Progl on 15.02.20.
//  Copyright © 2020 Veit Progl. All rights reserved.
//

import SwiftUI

struct LogInteractive: View {
	@EnvironmentObject var makerlogAPI: MakerlogAPI
	@EnvironmentObject var login: LoginData
	@EnvironmentObject var tabScreenData: TabScreenData

    @State var openEdit = false

	var log: LogViewData

//	@Binding var showDetailView: Bool

//	init(log: LogViewData, showDetailView: Binding<Bool>) {
//		self._showDetailView = showDetailView
//		self.log = log
//	}

	// swiftlint:disable empty_parentheses_with_trailing_closure
    var body: some View {
        HStack() {
			Spacer()

            HStack() {
                Text("\(self.log.data.praise)")
                    .padding(4)
                Image(systemName: "star")
            }
				.onTapGesture {
					if self.login.isLoggedIn == false {
//						self.tabScreenData.showLogin = true
                        self.tabScreenData.presentSheet = .showLogin
                        self.tabScreenData.showSheet = true
					} else {
						self.makerlogAPI.addPraise(log: self.log.data)
					}
				}
				
			Spacer()

			HStack() {
				Image(systemName: "bubble.right")
				Text("\(self.log.data.commentCount)")
			}
			Spacer()
			HStack() {
				Image(systemName: "link")
				Text("Copy link")
					.onTapGesture {
						let link = "https://getmakerlog.com/tasks/\(self.log.data.id)"
						UIPasteboard.general.string = link
					}
					.padding(4)
					.cornerRadius(6)
					.font(.footnote)
			}
			Spacer()
			if self.log.data.user.username == login.userData.first?.username ?? "" {
//				HStack() {
//					Image(systemName: "trash")
//					Text("Delete")
//						.onTapGesture {
//							self.makerlogAPI.deleteItem.toggle()
//						}
//						.padding(4)
//						.cornerRadius(6)
//						.font(.footnote)
//				}
                HStack() {
                    Image(systemName: "pencil.and.outline")
                    Text("Edit")
                        .onTapGesture {
                            self.openEdit.toggle()
                        }
                        .padding(4)
                        .cornerRadius(6)
                        .font(.footnote)
                }
				Spacer()
			}
		}
        .sheet(isPresented: self.$openEdit, onDismiss: {
            self.log.updateLog()
        },content: {
            AddView(log: self.log.data)
        })
    }
}
