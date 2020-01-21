//
//  LogView.swift
//  Makerlog
//
//  Created by Veit Progl on 21.01.20.
//  Copyright © 2020 Veit Progl. All rights reserved.
//

import Foundation
import SwiftUI
import URLImage

struct LogView: View {
    @ObservedObject var log: logViewData
    
    var body: some View {
        ScrollView() {
            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .center) {
                    URLImage(URL(string: self.log.data.user.avatar)!,
                             processors: [ Resize(size: CGSize(width: 70, height: 70), scale: UIScreen.main.scale) ],
                             content: {
                        $0.image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipped()
                        .cornerRadius(20)
                    })
                        .frame(width: 70, height: 70)
                    VStack(alignment: .leading) {
                        Text(self.log.data.user.username)
                            .font(.headline).bold()
                        
                        HStack(spacing: 10) {
                            Text("\(self.log.data.user.makerScore) 🏆")
                            Text("\(self.log.data.user.streak) 🔥")
                            Text("\(self.log.data.user.weekTda) 🏁")
                        }
                    }
                    Spacer()
                }
                .padding(10)
                .frame(minWidth: 0, maxWidth: .infinity)
                .background(Color.primary.opacity(0.1))
                .cornerRadius(10)
                
                Text(self.log.data.content)
                    .padding(10)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .background(Color.primary.opacity(0.1))
                    .cornerRadius(10)
                    .lineLimit(200)
                
                if self.log.data.attachment != nil {
                    URLImage(URL(string: self.log.data.attachment!)!,
                         content: {
                    $0.image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipped()
                    .cornerRadius(15)
                    })
                }
                
                if self.log.data.projectSet.first?.id != nil {
                    VStack(alignment: .leading) {
                        Text("Products: ").bold()
                        ForEach(self.log.data.projectSet) { project in
                            VStack(alignment: .leading) {
                                productView(data: productViewData(id: String(project.id)))
                            }.padding([.bottom], 10)
                        }
                    }.padding([.top], 10)
                }
                
                

                Spacer()
            }.padding()
            .padding([.top], 50)

        } .edgesIgnoringSafeArea(.top)
        
    }
}

//struct LogView_Previews: PreviewProvider {
//    static var previews: some View {
//        LogView(log: logViewData(data: Result(id: 22, done: false, inProgress: true, content: "wwww eerr wqew", createdAt: "", updatedAt: "", dueAt: "", doneAt: "", user: User(id: 2, username: "name", firstName: "first name", lastName: "last name", verified: true, userPrivate: true, avatar: "ww", streak: 22, timezone: "w", isStaff: false, donor: true, tester: false, isLive: false, digest: true, gold: false, accent: "", makerScore: 222, darkMode: false, weekendsOff: false, hardcoreMode: false), projectSet: , praise: <#T##Int#>, attachment: <#T##String?#>, commentCount: <#T##Int#>)))
//    }
//}
