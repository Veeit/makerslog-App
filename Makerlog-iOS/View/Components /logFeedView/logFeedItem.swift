//
//  logFeedItem.swift
//  Makerlog
//
//  Created by Veit Progl on 01.02.20.
//  Copyright © 2020 Veit Progl. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct LogFeedItem: View {
	var log: LogViewData
	@EnvironmentObject var tabScreenData: TabScreenData
	@EnvironmentObject var makerlogAPI: MakerlogAPI
	@EnvironmentObject var login: LoginData
	@State var showDetailView = false

	var body: some View {
		let cmenu = ContextMenu {
			Button("Open") {  self.showDetailView.toggle() }
			Button("👏 \(self.log.data.praise)") {
				self.makerlogAPI.addPraise(log: self.log.data)
			}
			if self.log.data.user.username == login.userData.first?.username ?? "" {
				Button("Delete") {
					self.makerlogAPI.deleteItem.toggle()
				}
			}
		}

		return NavigationLink(destination: LogDetailView(log: log, fromUser: false),
							  isActive: self.$showDetailView) {

            VStack(alignment: .leading) {
                HStack(alignment: .top) {
                    VStack(alignment: .trailing) {
                        WebImage(url: URL(string: log.data.user.avatar)!,
                                 options: [.decodeFirstFrameOnly],
                                 context: [.imageThumbnailPixelSize: CGSize(width: 80, height: 80)])
                            .placeholder(Image("imagePlaceholder"))
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40, height: 40)
                            .clipped()
                            .cornerRadius(20)

                        if (log.data.event != nil) {
                            EventImg(event: log.data.event ?? "")
                        } else {
                            ProgressImg(done: log.data.done, inProgress: log.data.inProgress)
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        HStack() {
                            VStack(alignment: .leading) {
                                Text(self.log.data.user.firstName != "" && self.log.data.user.lastName != "" ? "\(self.log.data.user.firstName ) \(self.log.data.user.lastName)" : self.log.data.user.username)
                                    .font(.subheadline).bold()
                                    .fixedSize()
                                HStack(spacing: 3) {
                                    Text(self.log.data.user.firstName != "" && self.log.data.user.lastName != "" ? "@\(self.log.data.user.username)" : "").font(.footnote)
                                    Text("\(log.data.user.streak) 🔥").font(.footnote)
                                }
                            }
                            Spacer()
                            VStack(alignment: .leading, spacing: 1) {
                                HStack(alignment: .center) {
                                    Text("\(self.log.data.praise)")
                                    Image(systemName: "star")
                                }
                                .drawingGroup()
                                .onTapGesture {
                                    if self.login.isLoggedIn == false {
                                       self.tabScreenData.presentSheet = .showLogin
                                       self.tabScreenData.showSheet = true
                                   } else {
                                       self.makerlogAPI.addPraise(log: self.log.data)
                                   }
                                }
                                Text(log.data.getDate()).font(.footnote)
                            }
                        }.frame(height: 48)

                        
                        Text(log.data.content)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding([.bottom], 15)
                    }
                }
                
                if log.data.description != nil {
                    HStack() {
                        Divider().frame(width: 2).background(Color.green)
                        Text(log.data.description ?? "no description found")
                    }.padding([.leading], 15)
                }
                
                if log.data.attachment != nil {
                    VStack(alignment: .center) {
                        WebImage(url: URL(string: log.data.attachment!),
                                 options: [.decodeFirstFrameOnly],
                                 context: [.imageThumbnailPixelSize : CGSize(width: 600, height: 600)])
                            .placeholder(Image("imagePlaceholder"))
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 300, height: 300)
                            .clipped()
                            .cornerRadius(7)
                        
                    }.frame(minWidth: 0, maxWidth: .infinity, maxHeight: 300)
                }
            }
		}
        .onTapGesture {
			self.showDetailView.toggle()
		}
		.contextMenu(cmenu)
		.alert(isPresented: self.$makerlogAPI.deleteItem, content: anAlert)
	}
    
	func anAlert() -> Alert {
        let send = ActionSheet.Button.default(Text("Send")) { self.makerlogAPI.deleteLog(log: self.log.data) }

        // If the cancel label is omitted, the default "Cancel" text will be shown
		let cancel = ActionSheet.Button.cancel(Text("Abort")) { self.makerlogAPI.deleteItem.toggle() }

        return Alert(title: Text("Delete"),
					 message: Text("Sure that you want to delete this log ?"),
					 primaryButton: send,
					 secondaryButton: cancel)
    }
}
