////
////  DiscussionsDetailView.swift
////  iOS
////
////  Created by Veit Progl on 13.02.20.
////  Copyright © 2020 Veit Progl. All rights reserved.
////
//
//import SwiftUI
//import KeyboardObserving
//import SwiftUIX
//import MDText
//import SDWebImageSwiftUI
//
//struct DiscussionsDetailView: View {
//	@ObservedObject var data: DiscussionData
//	@EnvironmentObject var tabScreenData: TabScreenData
//	@EnvironmentObject var login: LoginData
//
//	//swiftlint:disable empty_parentheses_with_trailing_closure multiple_closures_with_trailing_closure
//    var body: some View {
//		VStack() {
//			ZStack(alignment: .top) {
//				List() {
//					VStack(alignment: .leading) {
//						HStack(alignment: .top) {
//							WebImage(url: URL(string: self.data.discussion.owner.avatar)!,
//								 options: [.decodeFirstFrameOnly],
//								 context: [.imageThumbnailPixelSize: CGSize(width: 120, height: 120)])
//								.placeholder(Image("imagePlaceholder"))
//								.resizable()
//								.aspectRatio(contentMode: .fit)
//								.frame(width: 60, height: 60)
//								.clipped()
//								.cornerRadius(20)
//
//							Text("\(self.data.discussion.title)")
//								.font(.title)
//								.bold()
//								.lineLimit(nil)
//								.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .leading)
//								.fixedSize(horizontal: false, vertical: true)
//								.multilineTextAlignment(.leading)
//								.layoutPriority(2)
//						}
//
//						MDText(markdown: self.data.discussion.body)
//							.layoutPriority(2)
//							.padding([.bottom], 30)
//							.fixedSize(horizontal: false, vertical: true)
//					}
//
//					if self.data.discussionResponse != [] {
//						ForEach(self.data.discussionResponse) { response in
//							if response.parent_reply == nil {
//								VStack(alignment: .leading) {
//									ReplayView(response: response)
//								}.padding([.top], 5)
//								ForEach(self.data.getReplyReplys(reply: response).reversed()) { reply in
//									VStack() {
//										HStack(alignment: .top) {
//											VStack() {
//												WebImage(url: URL(string: "\(reply.owner.avatar)"),
//													 options: [.decodeFirstFrameOnly],
//													 context: [.imageThumbnailPixelSize: CGSize(width: 90, height: 90)])
//													.placeholder(Image("imagePlaceholder"))
//													.resizable()
//													.aspectRatio(contentMode: .fit)
//													.frame(width: 45, height: 45)
//													.clipped()
//													.cornerRadius(20)
//											}
//
//											VStack(alignment: .leading) {
//												MDText(markdown: "\(reply.body)")
//													.lineLimit(nil)
//													.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .leading)
//													.fixedSize(horizontal: false, vertical: true)
//												HStack() {
//													Text("@\(reply.owner.username)").bold()
//													Text("👏 \(reply.praise)")
//													Spacer()
//												}
//
//											}.padding([.leading], 10)
//										}.padding([.leading], 30 )
//									}
//								}
//							}
//						}
//                    } else if self.data.discussion.reply_count == 0 {
//						Text("Be the first to reply!")
//                    } else {
//                        Text("loading ...!")
//                    }
//
//				}.padding([.bottom], 60)
//
//				VStack() {
//					Spacer()
//					VStack() {
//						Divider()
//						HStack() {
//							Button(action: {
//								UIApplication.shared.endEditing()
//								self.data.reply = ""
//							}) {
//								Image(systemName: "xmark.square")
//									.imageScale(.large)
//									.foregroundColor(Color.blue)
//							}
//							TextField("Add a comment", text: self.$data.reply)
//							Button(action: {
//								if self.login.isLoggedIn == false {
////									self.tabScreenData.showLogin = true
//                                    self.tabScreenData.presentSheet = .showLogin
//                                    self.tabScreenData.showSheet = true
//								} else {
//									self.data.postReply()
//								}
//								self.data.reply = ""
//							}) {
//								Text("Send")
//							}
//						}
//					}
//					.keyboardObserving()
//					.padding([.leading, .trailing, .bottom])
//					.padding([.top], 0)
//					.background(Color.systemBackground)
//				}
//			}
//		}.onAppear(perform: {
//			self.data.getDissucionsReplies()
//		})
//		.navigationBarTitle("\(self.data.discussion.title)", displayMode: .inline)
//		.navigationBarItems(trailing:
//			Button(action: {
//				self.data.getDissucionsReplies()
//			}) {
//				Image(systemName: "arrow.2.circlepath")
//			}
//		)
//	}
//
//}
