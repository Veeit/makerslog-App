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
    
    var body: some View {
        
        RefreshableNavigationView(title: "Logs", action:{
            self.data.getResult()
        }){
            ForEach(self.data.logs){ log in
                NavigationLink(destination: LogView(log: logViewData(data: log))) {
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
                        
                        Text(log.content)
                            .padding([.bottom], 15)
                        
                        if log.attachment != nil {
                            URLImage(URL(string: log.attachment!)!,
                                     content: {
                                $0.image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .clipped()
                                .cornerRadius(15)
                            })
                        }
                    }
                }
            }
        }.edgesIgnoringSafeArea([.bottom])
         .padding([.top], 1)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
