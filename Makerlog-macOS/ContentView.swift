//
//  ContentView.swift
//  makerlog-macOS
//
//  Created by Veit Progl on 05.02.20.
//  Copyright © 2020 Veit Progl. All rights reserved.
//

import SwiftUI
import OAuthSwift
import KeychainSwift
import URLImage

struct ContentView: View {
    var body: some View {
		NavigationView() {
			List() {
				Text("ww")
				Text("ww")
			}.listStyle(SidebarListStyle())
		}
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
