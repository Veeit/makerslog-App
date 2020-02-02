//
//  LogFeedView.swift
//  Makerlog
//
//  Created by Veit Progl on 20.01.20.
//  Copyright © 2020 Veit Progl. All rights reserved.
//

import SwiftUI
import Foundation
import URLImage
//import SwiftUIPullToRefresh

struct LogFeedView: View {
    // swiftlint:disable all
    @EnvironmentObject var tabScreenData: TabScreenData
    @ObservedObject var data = MakerlogAPI()
    @ObservedObject var login = LoginData()
    let defaultAvartar = "https://gravatar.com/avatar/d3df4c9fe1226f2913c9579725c1e4aa?s=150&d=mm&r=pg"

    var body: some View {
        GeometryReader() { geometry in

            RefreshableNavigationViewWithItem(title: "Makerlog", action: {
                self.data.getResult()
            }, isDone: self.$data.isDone, leadingItem: {
                EmptyView()
            }, trailingItem: {
                URLImage(URL(string: self.login.meData.first?.avatar ?? self.defaultAvartar)!,
                         processors: [ Resize(size: CGSize(width: 40, height: 40), scale: UIScreen.main.scale) ],
                         content: {
                    $0.image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipped()
                    .cornerRadius(20)
                })
                    .frame(width: 40, height: 40)
                    .onTapGesture {
                        self.tabScreenData.userSheet.toggle()
                }
            }) {
                Text(self.login.meData.first?.firstName ?? "ww")

                Button(action: {
                    self.login.login()
                }) {
                    Text("save login").foregroundColor(Color.blue)
                }

                Button(action: {
                    self.login.getMe()
                   }) {
                       Text("get me").foregroundColor(Color.blue)
                   }

                ForEach(self.data.logs) { log in
                    LogFeedItem(log: log)
                }
            }
            .edgesIgnoringSafeArea(.bottom)
            .onAppear(perform: {
                let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
                print(urls[urls.count-1] as URL)
            })
        }
    }

    struct EventView: View {
        @Binding var event: String

        var body: some View {
            Text("ww")
        }
    }
}

struct LogFeedView_Previews: PreviewProvider {
    static var previews: some View {
        LogFeedView()
    }
}
