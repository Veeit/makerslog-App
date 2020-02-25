//
//  SettingsView.swift
//  iOS
//
//  Created by Veit Progl on 24.02.20.
//  Copyright © 2020 Veit Progl. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
	var data: TabScreenData
	var loginData: LoginData
    var body: some View {
		NavigationView() {
			List() {
				Section() {
					NavigationLink(destination: Imprint()) {
						Text("📖 Imprint")
					}
					NavigationLink(destination: DataSecurity()) {
						Text("📖 Datasecurity")
					}
				}

				Section(header: Text("Contact")) {
					Button(action: {
						self.openTelegramLink()
					}) {
						Text("Telegram")
					}
				}
				
				Section() {
					Button(action: {
						self.loginData.logOut()
					}) {
						Text("Logout")
					}
					
					Button(action: {
						self.data.showOnboarding = true
					}) {
						Text("Show Onbording")
					}
					Button(action: {
						self.loginData.logOut()
					}) {
						Text("Delete all Data").foregroundColor(Color.red)
					}
				}
			}
			.listStyle(GroupedListStyle())
			.navigationBarTitle("Settings")
		}
    }
	func openTelegramLink() {
		if let url = URL(string: "https://t.me/Veitpro") {
			UIApplication.shared.open(url)
		}
	}
}
