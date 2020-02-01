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
import SwiftUIPullToRefresh

struct LogFeedView: View {
    @ObservedObject var data = makerlogAPI()
    @ObservedObject var login = loginData()
    
    var body: some View {
        GeometryReader() { geometry in

            RefreshableNavigationViewWithItem(title: "Makerlog", action: {
                self.data.getResult()
            },isDone: self.$data.isDone, leadingItem: {
                EmptyView()
            }, trailingItem: {
                URLImage(URL(string: self.login.meData.first?.avatar ?? "https://gravatar.com/avatar/d3df4c9fe1226f2913c9579725c1e4aa?s=150&d=mm&r=pg")!,
                         processors: [ Resize(size: CGSize(width: 40, height: 40), scale: UIScreen.main.scale) ],
                         content: {
                    $0.image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipped()
                    .cornerRadius(20)
                })
                    .frame(width: 40, height: 40)
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
                            
                            HStack(alignment: .top) {
                                if log.done {
                                    Image(systemName: "checkmark.circle").padding([.top], 5)
                                }
                                if log.inProgress {
                                    Image(systemName: "circle").padding([.top], 5)
                                }
                                Text(log.event ?? "")
//                                if (String(log.event) == "github") {
//                                    Text("wwr")
//                                }
                                
                                Text(log.content)
                                    .padding([.bottom], 15)
                                    .lineLimit(20)
                                
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
            }
            .edgesIgnoringSafeArea(.bottom)
            .onAppear(perform: {
                let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
                print(urls[urls.count-1] as URL)
               
            })
        }
    }
    
    struct eventView: View {
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
