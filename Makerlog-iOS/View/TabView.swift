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
		.alert(isPresented: self.$data.showError, content: {errorAlert(errorMessage: self.data.errorText)})
		.alert(isPresented: self.$makerlog.showError, content: {errorAlert(errorMessage: self.makerlog.errorText)})
		.alert(isPresented: self.$login.showDatapolicyAlert, content: {anAlert()})
		.sheet(isPresented: self.$data.showLogin, content: {LoginScreen(login: self.login)})
		.overlay(VStack() {
			if self.data.showOnboarding {
				Onboarding()
			} else {
				EmptyView()
			}
		})
	}

	func errorAlert(errorMessage: String) -> Alert {
		let send = ActionSheet.Button.default(Text("okay")) { print("hit send") }
		return Alert(title: Text("Error!"), message: Text(errorMessage), dismissButton: send)
	}
	
	func anAlert() -> Alert {
        let save = ActionSheet.Button.default(Text("Okay, I'm fine ")) { print("hit save") }

        // If the cancel label is omitted, the default "Cancel" text will be shown
        let cancel = ActionSheet.Button.cancel(Text("No")) { print("hit abort") }
        
        return Alert(title: Text("Datasecurity is important"),
                     message: Text("""
	You need to read the datasecurity policy first, you will accept is automatily when you login.
	If you don't like the datapolicy I can't let you login because the login feature requires that I send data to makerlog.
	A Sort summery of the datapolicy: I do not save any of your data, I need to send it to getmakerlog.com to shere your Comments / Logs / Disscussions [...] with the community.
	To delete all of your data you need to go to getmakerlog.com and delte it there!
	"""),
                     primaryButton: save,
                     secondaryButton: cancel)
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
