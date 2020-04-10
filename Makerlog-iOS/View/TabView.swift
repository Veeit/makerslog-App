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
	@State private var selection: Int = 0

	var body: some View {
		VStack() {
//			Text(String(self.login.showDatapolicyAlert))
            TabView {
                LogFeedView()
                .sheet(isPresented: self.$data.showSettings, content: {
                    SettingsView(data: self.data, loginData: self.login)
                })
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
			.alert(isPresented: self.$data.showError, content: {errorAlert(errorMessage: self.data.errorText)})
			.alert(isPresented: self.$makerlog.showError, content: {errorAlert(errorMessage: self.makerlog.errorText)})
			.sheet(isPresented: self.$data.showLogin, content: {LoginScreen(login: self.login)})
		}.sheet(isPresented: self.$data.showDataPolicy, content: {
			NavigationView() {
				DataSecurity()
			}.navigationViewStyle(StackNavigationViewStyle())
		})
	}

	func errorAlert(errorMessage: String) -> Alert {
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
