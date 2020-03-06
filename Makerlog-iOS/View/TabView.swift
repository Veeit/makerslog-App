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

    @State private var showDataPolicy: Bool = false
	// swiftlint:disable empty_parentheses_with_trailing_closure

	var body: some View {
		VStack() {
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
			.overlay(VStack() {
				if self.data.showOnboarding {
					Onboarding()
				} else {
					EmptyView()
				}
			})
			.alert(isPresented: self.$data.showError, content: {errorAlert(errorMessage: self.data.errorText)})
			.alert(isPresented: self.$makerlog.showError, content: {errorAlert(errorMessage: self.makerlog.errorText)})
			.alert(isPresented: self.$login.showDatapolicyAlert, content: {datasecurityAlert()})
			.sheet(isPresented: self.$data.showLogin, content: {LoginScreen(login: self.login)})
			
		}.sheet(isPresented: self.$showDataPolicy, content: {
			NavigationView() {
				DataSecurity()
			}.navigationViewStyle(StackNavigationViewStyle())
		})
	}

	func errorAlert(errorMessage: String) -> Alert {
		let send = ActionSheet.Button.default(Text("okay")) { print("hit send") }
		return Alert(title: Text("Error!"), message: Text(errorMessage), dismissButton: send)
	}

	func datasecurityAlert() -> Alert {
		let save = ActionSheet.Button.default(Text("Accept")) {
			self.login.acceptDatapolicy()
			self.login.login()
			self.data.setOnbaording()
			self.data.showOnboarding = false
		}

        // If the cancel label is omitted, the default "Cancel" text will be shown
		let cancel = ActionSheet.Button.cancel(Text("Open policy")) { self.showDataPolicy = true }

        return Alert(title: Text("Datasecurity is important"),
                     message: Text("""
	You need to read the datasecurity policy first.
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
