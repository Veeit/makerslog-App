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
		List() {
			Text("Settings").font(Font.largeTitle.bold())
			Text("Hello, World!")
		}
		.listStyle(GroupedListStyle())
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
