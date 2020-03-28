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

	@State var showData = false   
	var body: some View {
		NavigationView() {
			List() {
				ForEach(self.data.logs) { log in
					LogFeedItem(log: LogViewData(data: log))
				}
			}
			.navigationBarTitle("LogBot", displayMode: .large)
			.navigationBarItems(leading:
						Button(action: {
							self.tabScreenData.showSettings = true
						}) {
							Image(systemName: "gear").imageScale(.large)
						},
					trailing:
						HStack() {
							Button(action: {
								self.data.getLogs()
							}) {
								Image(systemName: "arrow.2.circlepath")
							}.padding([.trailing], 8)

							if self.login.isLoggedIn == true {
								NavigationLink(destination: UserView(userData: self.login.userData),
											   isActive: self.$tabScreenData.userSheet) {
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
										self.showData.toggle()
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
			.alert(isPresented: $showData, content: {datasecurityAlert()})
		}
	}

	struct EventView: View {
		@Binding var event: String

		var body: some View {
			Text("ww")
		}
	}
	
	func datasecurityAlert() -> Alert {
		let save = ActionSheet.Button.default(Text("Accept")) {
			self.login.acceptDatapolicy()
			self.login.login()
			self.tabScreenData.setOnbaording()
			self.tabScreenData.showOnboarding = false
		}

        // If the cancel label is omitted, the default "Cancel" text will be shown
		let cancel = ActionSheet.Button.cancel(Text("Open policy")) {
			self.tabScreenData.showDataPolicy.toggle()
		}

        return Alert(title: Text("Datasecurity is important"),
                     message: Text("""
	You need to read the datasecurity policy first.
	"""),
                     primaryButton: save,
                     secondaryButton: cancel)
    }

}

struct LogFeedView_Previews: PreviewProvider {
	static var previews: some View {
		LogFeedView()
	}
}
