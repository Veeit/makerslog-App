//
//  TabScreen.swift
//  Makerlog
//
//  Created by Veit Progl on 27.01.20.
//  Copyright © 2020 Veit Progl. All rights reserved.
//

import SwiftUI

class TabScreenData: ObservableObject {
    @Published var userSheet = false
}

struct TabScreen: View {
    @EnvironmentObject var data: TabScreenData
    @EnvironmentObject var login: LoginData
    
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

        }.sheet(isPresented: self.$data.userSheet, content: {
            UserView(user: self.$login.meData)
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
