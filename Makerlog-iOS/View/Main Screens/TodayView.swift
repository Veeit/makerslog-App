//
//  TodayView.swift
//  iOS
//
//  Created by Veit Progl on 20.07.20.
//  Copyright © 2020 Veit Progl. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct TodayView: View {
    @State private var openAddSheet = false
//    @EnvironmentObject var user: UserData
    let defaultAvartar = "https://gravatar.com/avatar/d3df4c9fe1226f2913c9579725c1e4aa?s=150&d=mm&r=pg"
    @State private var logTextField =  ""
    @ObservedObject var user = UserData()
    
    
    var body: some View {
        NavigationView() {
            List() {
                HStack() {
                    HStack() {
                        VStack() {
                            WebImage(url: URL(string: self.user.userData.first?.avatar ?? self.defaultAvartar),
                                 options: [.decodeFirstFrameOnly],
                                 context: [.imageThumbnailPixelSize: CGSize(width: 240, height: 240)])
                            .placeholder(Image("imagePlaceholder"))
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 120, height: 120)
                            .clipped()
                            .cornerRadius(20)
                            
//                            Text(user.userName)
                        }
                    }
                    HStack() {
                        VStack(alignment: .leading) {
                            HStack() {
                                Image(systemName: "bed.double")
                                Text("\(self.user.userStats.first?.rest_day_balance ?? 0)")
                            }.drawingGroup()
                            
                            HStack() {
                                Image(systemName: "person.3")
                                Text("\(self.user.userStats.first?.follower_count ?? 0)")
                            }.drawingGroup()
                            
                            HStack() {
                                Image(systemName: "speedometer")
                                Text("\(self.user.userStats.first?.maker_score ?? 0)")
                            }.drawingGroup()
                            
                            HStack() {
                                Image(systemName: "flame")
                                Text("\(self.user.userStats.first?.streak ?? 0)")
                            }.drawingGroup()
                            
//                            HStack() {
//                                Image(systemName: "checkmark.circle")
//                                Text("\(self.user.userStats.first?.done_today ?? 0)")
//                            }.drawingGroup()
//
//                            HStack() {
//                                Image(systemName: "circle")
//                                Text("\(self.user.userStats.first?.remaining_tasks ?? 0)")
//                            }.drawingGroup()
                        }
                        Spacer()
                    }
                }
                
                Section(header: "Todo") {
                    Text("Todo / Done Today")
                    
                }
                
                if self.user.notification != nil {
                    Section(header: "Notification") {
                        ForEach(self.user.notification!) { notification in
                           HStack() {
                               WebImage(url: URL(string: notification.actor.avatar)!,
                                    options: [.decodeFirstFrameOnly],
                                    context: [.imageThumbnailPixelSize : CGSize(width: 120, height: 120)])
                               .placeholder(Image("imagePlaceholder"))
                               .resizable()
                               .aspectRatio(contentMode: .fit)
                               .frame(width: 60, height: 60)
                               .clipped()
                               .cornerRadius(20)
                               VStack(alignment: .leading) {
                                   Text("\((notification.actor.username))").bold()
                                   if notification.target != nil {
                                       TargetView(notification: notification)
                                   }
                               }
                           }
                       }
                    }
                }
                
                if self.user.archivments != nil {
                    Section(header: "Archivments") {
                        ForEach(self.user.archivments!) { archivment in
                            Text("\(archivment.data.name)")
                        }
                    }
                }
                
                Text("Statistics")
                
            }
            .sheet(isPresented: self.$openAddSheet, content: {
                AddView()
            })
            .navigationBarTitle("Today")
            .navigationBarItems(
                leading:
                    HStack() {
                        Button(action: {
                            self.openAddSheet.toggle()
                        }) {
                            Image(systemName: "plus")
                        }.padding([.leading], 8)
                    },
                trailing:
                    HStack() {
                        Button(action: {
                            self.loadAllData()
                        }) {
                            Image(systemName: "arrow.2.circlepath")
                        }.padding([.trailing], 8)
                    }
                )
        }.onAppear(perform: {
            self.loadAllData()
        })
    }
    
    struct TargetView: View {
        var notification: NotificationElement
        var body: some View {
            VStack(alignment: .leading) {
                if notification.target?.title != nil {
                    Text("✍️ \((notification.target?.title!)!)")
                    Text("\((notification.verb))").font(.subheadline)
                } else if notification.target?.content != nil {
                    HStack() {
                        Text("\(notification.target?.praise ?? 0)").font(.subheadline)
                        Image(systemName: "star").imageScale(.small)
                        Text("\((notification.verb))").font(.subheadline)
                    }.drawingGroup().frame(height: 5)
                    Text("\((notification.target?.content!)!)")
                }
            }
        }
    }
    
    func loadAllData() {
        self.user.getUser()
        self.user.getUserName()
        self.user.getUserStats()
        self.user.getNotifications()
        self.user.getArchivments()
    }
}

struct TodayView_Previews: PreviewProvider {
    static var previews: some View {
        TodayView()
    }
}
