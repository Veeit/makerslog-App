//
//  TodayView.swift
//  iOS
//
//  Created by Veit Progl on 20.07.20.
//  Copyright © 2020 Veit Progl. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI
import SwiftUICharts

struct TodayView: View {
    @State private var openAddSheet = false
//    @EnvironmentObject var user: UserData
    let defaultAvartar = "https://gravatar.com/avatar/d3df4c9fe1226f2913c9579725c1e4aa?s=150&d=mm&r=pg"
    @State private var logTextField =  ""
    @ObservedObject var user: UserData
    
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
                    VStack() {
                        if self.user.userData.first?.firstName != "" && self.user.userData.first?.lastName != "" {
                            VStack(alignment: .leading) {
                                
                                Text("\(self.user.userData.first?.firstName ?? "") \(self.user.userData.first?.lastName ?? "")")
                                    .font(.headline).bold()
                                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                  Text("@\(self.user.userData.first?.username ?? "")")
                                      .font(.subheadline)
                                      .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            }
                        } else {
                            Text("@\(self.user.userData.first?.username ?? "")")
                                .font(.headline)
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        }
                        
                         HStack() {
                            HStack() {
                                VStack(alignment: .center) {
                                    Image(systemName: "bed.double")
                                    Image(systemName: "person.3")
                                }
                                
                                VStack(alignment: .leading) {
                                    Text("\(self.user.userStats.first?.rest_day_balance ?? 0)")
                                    Text("\(self.user.userStats.first?.follower_count ?? 0)")
                                }
                            }
                            Spacer()
                            HStack() {
                                VStack(alignment: .center) {
                                    Image(systemName: "speedometer")
                                    Image(systemName: "flame")
                                }
                                
                                VStack(alignment: .leading) {
                                    Text("\(self.user.userStats.first?.maker_score ?? 0)")
                                    Text("\(self.user.userStats.first?.streak ?? 0)")
                                }
                            }
                            Spacer()
                        }
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
                            HStack() {
                                Image(systemName: "flag.fill")
                                Text("\(archivment.data.name)")
                            }
                        }
                    }
                }
                                
                Section(header: "Statistics") {
                     LineView(data: self.user.userStats.first?.activity_trend ?? [4, 4, 4, 4, 4], title: "Productivity", legend: "Your weekly productivity")
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 320, maxHeight: .infinity)
                        .padding([.bottom], 100)
//                    .fixedSize()
                }
                
            }
        .listStyle(GroupedListStyle())
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
        .navigationViewStyle(StackNavigationViewStyle())
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
        self.user.getArchivments()
        self.user.getUserStats()
        self.user.getNotifications()
    }
}

//struct TodayView_Previews: PreviewProvider {
//    static var previews: some View {
//        TodayView(user: <#T##UserData#>)
//    }
//}
