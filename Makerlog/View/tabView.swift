//
//  TabScreen.swift
//  Makerlog
//
//  Created by Veit Progl on 27.01.20.
//  Copyright © 2020 Veit Progl. All rights reserved.
//

import SwiftUI
import PartialSheet

class TabScreenData: ObservableObject {
    @Published var userSheet = false
}

struct TabScreen: View {
    @EnvironmentObject var data: TabScreenData
    @EnvironmentObject var login: LoginData
    // swiftlint:disable empty_parentheses_with_trailing_closure

    var body: some View {
        TabView {
            VStack {
                LogFeedView()
            }
            .tabItem({ TabLabel(imageName: "house.fill", label: "Home") })

            VStack {
                Text("Search Tab")
            }
            .tabItem({ TabLabel(imageName: "magnifyingglass", label: "Search") })

        }
        .partialSheet(presented: self.$data.userSheet, view: {
            VStack() {
                UserView(user: self.$login.meData)
                Spacer()
            }
        })
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
