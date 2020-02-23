//
//  TabScreen.swift
//  Makerlog
//
//  Created by Veit Progl on 27.01.20.
//  Copyright © 2020 Veit Progl. All rights reserved.
//

import SwiftUI
import Down

class TabScreenData: ObservableObject {
	@Published var userSheet = false

	@Published var showDetailView = false
	@Published var showError = false
	@Published var errorText = "unknown error"
}

struct TabScreen: View {
    @EnvironmentObject var data: TabScreenData
	@EnvironmentObject var login: LoginData
	@EnvironmentObject var makerlog: MakerlogAPI
    // swiftlint:disable empty_parentheses_with_trailing_closure

    var body: some View {
		TabView {
			VStack {
				LogFeedView()
			}
			.tabItem({ TabLabel(imageName: "house.fill", label: "Home") })

			VStack {
				DiscussionsView()
			}
			.tabItem({ TabLabel(imageName: "bubble.left.and.bubble.right.fill", label: "Discussions") })

            VStack {
				AddView()
			}
            .tabItem({ TabLabel(imageName: "plus.square.fill", label: "Add") })

			VStack {
				NotificationsView()
			}
			.tabItem({ TabLabel(imageName: "bell.fill", label: "Notification") })

        }
		.sheet(isPresented: self.$data.userSheet, content: {UserView(login: self.login)})
		.alert(isPresented: self.$data.showError, content: {anAlert(errorMessage: self.data.errorText)})
		.alert(isPresented: self.$makerlog.showError, content: {anAlert(errorMessage: self.makerlog.errorText)})
    }

	func anAlert(errorMessage: String) -> Alert {
		let send = ActionSheet.Button.default(Text("okay")) { print("hit send") }
		return Alert(title: Text("Error!"), message: Text(errorMessage), dismissButton: send)
	}

    struct TabLabel: View {
           let imageName: String
           let label: String

           var body: some View {
               HStack {
                   Image(systemName: imageName)
                   Text(label)
               }
           }
       }
}

struct TabScreen_Previews: PreviewProvider {
    static var previews: some View {
        TabScreen()
    }
}
