//
//  LogFeedView.swift
//  Makerlog
//
//  Created by Veit Progl on 20.01.20.
//  Copyright © 2020 Veit Progl. All rights reserved.
//

import SwiftUI
import Foundation
import SDWebImageSwiftUI
//import SwiftUIPullToRefresh

struct LogFeedView: View {
	// swiftlint:disable all
	@EnvironmentObject var tabScreenData: TabScreenData
	@EnvironmentObject var data: MakerlogAPI
	@EnvironmentObject var login: LoginData
	@ObservedObject var addData = AddLogData()
	let defaultAvartar = "https://gravatar.com/avatar/d3df4c9fe1226f2913c9579725c1e4aa?s=150&d=mm&r=pg"

	var body: some View {
//		GeometryReader() { geometry in
			RefreshablListView(action: {
				self.data.getLogs()
			}, isDone: self.$data.isDone) {
//					Button(action: {
//						self.tabScreenData.showLogin = true
//					}) {
//						Text("test")
//					}
				ForEach(self.data.logs) { log in
					LogFeedItem(log: LogViewData(data: log))
				}
			}
//		}
		.navigationBarTitle("LogBot", displayMode: .large)
		.navigationBarItems(leading:
					Button(action: {
						self.tabScreenData.showSettings = true
					}) {
						Image(systemName: "gear").imageScale(.large)
					},
				trailing:
					VStack() {
						if self.login.isLoggedIn == true {
							
							NavigationLink(destination: UserView(userData: self.login.userData), isActive: self.$tabScreenData.userSheet) {
								Text("User")
							}.overlay(
								WebImage(url: URL(string: self.login.userData.first?.avatar ?? self.defaultAvartar),
									 options: [.decodeFirstFrameOnly],
									 context: [.imageThumbnailPixelSize : CGSize(width: 80, height: 80)])
								.placeholder(Image("imagePlaceholder"))
								.resizable()
								.aspectRatio(contentMode: .fit)
								.frame(width: 40, height: 40)
								.clipped()
								.cornerRadius(20)
								.onTapGesture {
									self.tabScreenData.userSheet = true
								}
							)
						} else {
							Button(action: {
								if self.login.acceptedDatapolicy == false {
									self.login.showDatapolicyAlert = true
								} else {
									self.login.login()
									self.login.getUser()
								}
							}) {
								Text("Login").foregroundColor(Color.blue)
							}
						}
					}
				)
		.onAppear(perform: {
			let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
			print(urls[urls.count-1] as URL)
		})
	}

	struct EventView: View {
		@Binding var event: String

		var body: some View {
			Text("ww")
		}
	}

}

struct LogFeedView_Previews: PreviewProvider {
	static var previews: some View {
		LogFeedView()
	}
}
