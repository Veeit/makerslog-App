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
	@EnvironmentObject var tabScreenData: TabScreenData
	@EnvironmentObject var data: MakerlogAPI
	@EnvironmentObject var login: LoginData
    @EnvironmentObject var device: Device
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
			.navigationBarItems(
					trailing:
						HStack() {
							Button(action: {
								self.data.getLogs()
							}) {
								Image(systemName: "arrow.2.circlepath")
							}.padding([.trailing], 8)

							
						}
					)
			.onAppear(perform: {
				let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
				print(urls[urls.count-1] as URL)
			})
			.alert(isPresented: $showData, content: {datasecurityAlert()})
		}.navigationViewStyle(StackNavigationViewStyle())
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
//			self.tabScreenData.showDataPolicy.toggle()
            self.tabScreenData.presentSheet = .showDataPolicy
            self.tabScreenData.showSheet = true
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
