//
//  TabScreen.swift
//  Makerlog
//
//  Created by Veit Progl on 27.01.20.
//  Copyright © 2020 Veit Progl. All rights reserved.
//

import SwiftUI

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
			.sheet(isPresented: self.$data.showSettings, content: {
				SettingsView(data: self.data, loginData: self.login)
			})

			VStack {
				DiscussionsView()
			}
			.tabItem({ TabLabel(imageName: "bubble.left.and.bubble.right.fill", label: "Discussions") })

			if login.isLoggedIn {
				VStack {
					AddView()
				}
				.tabItem({ TabLabel(imageName: "plus.square.fill", label: "Add") })

				VStack {
					NotificationsView()
				}
				.tabItem({ TabLabel(imageName: "bell.fill", label: "Notification") })
			}
		}
		.alert(isPresented: self.$data.showError, content: {anAlert(errorMessage: self.data.errorText)})
		.alert(isPresented: self.$makerlog.showError, content: {anAlert(errorMessage: self.makerlog.errorText)})
		.sheet(isPresented: self.$data.showLogin, content: {LoginScreen(login: self.login)})
		.overlay(VStack() {
			if self.data.showOnboarding {
				Onboarding()
			} else {
				EmptyView()
			}
		})
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
