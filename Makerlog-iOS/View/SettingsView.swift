//
//  SettingsView.swift
//  iOS
//
//  Created by Veit Progl on 24.02.20.
//  Copyright © 2020 Veit Progl. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
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
			}
			.listStyle(GroupedListStyle())
			.navigationBarTitle("Settings")
		}
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
