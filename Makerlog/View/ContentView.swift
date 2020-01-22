//
//  ContentView.swift
//  Makerlog
//
//  Created by Veit Progl on 20.01.20.
//  Copyright © 2020 Veit Progl. All rights reserved.
//

import SwiftUI
import Foundation
import URLImage
import SwiftUIPullToRefresh

struct ContentView: View {
    @ObservedObject var data = makerlogAPI()
    @ObservedObject var login = loginData()
    
    var body: some View {
        
        GeometryReader() { geometry in
            RefreshableNavigationView(title: "Makerlog", action:{
                self.data.getResult()
            }){
                Button(action: {
                    self.login.saveLogin()
                }) {
                    Text("save login").foregroundColor(Color.blue)
                }
                Button(action: {
                    self.login.isOpen = true
                }) {
                    Text("login").foregroundColor(Color.blue)
                }
                ForEach(self.data.logs){ log in
                    NavigationLink(destination: LogView(log: logViewData(data: log), comments: commentViewData(logID: String(log.id)))) {
                        VStack(alignment: .leading) {
                            HStack() {
                                URLImage(URL(string: log.user.avatar)!,
                                         processors: [ Resize(size: CGSize(width: 40, height: 40), scale: UIScreen.main.scale) ],
                                         content: {
                                    $0.image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .clipped()
                                    .cornerRadius(20)
                                })
                                    .frame(width: 40, height: 40)
                                Text(log.user.username).font(.subheadline).bold()
                                Spacer()
                                
                                Text("\(log.user.makerScore) 🏆")
                            }
                            
                            HStack() {
                                Text(log.content)
                                    .padding([.bottom], 15)
                                
                                if log.praise > 0 {
                                    Spacer()
                                    Text("\(log.praise) 👏")
                                }
                            }
                            
                            
                            if log.attachment != nil {
                                URLImage(URL(string: log.attachment!)!,
                                         content: {
                                    $0.image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .clipped()
                                    .cornerRadius(7)
                                })
                            }
                        }
                    }
                }
            }.edgesIgnoringSafeArea([.bottom])
             .padding([.top], 1)
            .addBoard(Board: {
                loginView(data: self.login)
            }, isShowing: self.$login.isOpen)
            .onAppear(perform: {
                let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
                print(urls[urls.count-1] as URL)
            })
                .addNavigationBar(Board: {
                    Text("w")
                })
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
