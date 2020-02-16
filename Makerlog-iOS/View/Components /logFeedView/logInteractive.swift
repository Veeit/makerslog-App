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
	var log: LogViewData

	@Binding var showDetailView: Bool
	

	init(log: LogViewData, showDetailView: Binding<Bool>) {
		self._showDetailView = showDetailView
		self.log = log
	}

    var body: some View {
        HStack() {
			Spacer()
			Text("👏 \(self.log.data.praise)")
				.onTapGesture {
					self.makerlogAPI.addPraise(log: self.log.data)
				}
				.padding(4)
				.cornerRadius(6)
				.font(.footnote)

			Spacer()
//			if showDetailView != nil {
//				HStack() {
//					Image(systemName: "arrow.turn.left.up").imageScale(.small)
//					Text("Reply")
//						.onTapGesture {
//							self.showDetailView.toggle()
//						}
//						.padding(4)
//						.cornerRadius(6)
//						.font(.footnote)
//				}
//			}
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
			if self.log.data.user.username == login.meData.first?.username ?? "" {
				HStack() {
					Image(systemName: "trash")
					Text("Delete")
						.onTapGesture {
							self.makerlogAPI.deleteItem.toggle()
						}
						.padding(4)
						.cornerRadius(6)
						.font(.footnote)
				}
			}
		}
    }
}
