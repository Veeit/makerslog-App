//
//  LogView.swift
//  Makerlog
//
//  Created by Veit Progl on 21.01.20.
//  Copyright © 2020 Veit Progl. All rights reserved.
//

import Foundation
import SwiftUI
import SDWebImageSwiftUI
import KeyboardObserving

struct LogDetailView: View {
    // swiftlint:disable empty_parentheses_with_trailing_closure
	@ObservedObject var log: LogViewData
	@ObservedObject var comments = CommentViewData()

//	@State var userComments = Comment()
	let defaultAvartar = "https://gravatar.com/avatar/d3df4c9fe1226f2913c9579725c1e4aa?s=150&d=mm&r=pg"
//	var userData = UserData()
	var fromUser = false

	init(log: LogViewData, fromUser: Bool) {
		self.log = log
		self.fromUser = fromUser
//		self.userData.userData = [self.log.data.user]
	}
    var body: some View {
		GeometryReader() { geometry in
			ZStack() {
				List() {
					if self.fromUser {
						UserHeader(log: self.log)
					} else {
						NavigationLink(destination: UserView(userData: [self.log.data.user])) {
							UserHeader(log: self.log)
						}
					}

					LogInteractive(log: self.log).offset(x: -10)

                    if self.log.data.projectSet != nil {
                        Section(header: Text("Products:")) {
                            ForEach(self.log.data.projectSet ?? [Projects]()) { project in
                                VStack(alignment: .leading) {
                                    ProductView(data: ProductViewData(projectID: String(project.id)))
                                }
                                .padding([.top, .bottom], 10)
                                .frame(minHeight: 60)
                            }
                        }
                    }

					if self.log.data.attachment != nil {
						Section() {
							WebImage(url: URL(string: self.log.data.attachment ?? "")!,
								 options: [.decodeFirstFrameOnly])
							.placeholder(Image("imagePlaceholder"))
							.resizable()
							.aspectRatio(contentMode: .fit)
							.frame( maxWidth: geometry.size.width - 20)
							.clipped()
							.cornerRadius(7)
						}
					}

					Section(header: Text("Comments: ") ) {
						ForEach(self.comments.comments) { comment in
							CommentView(comment: comment)
						}
					}

				}.padding([.bottom], 60)

				VStack() {
					Spacer()
					AddComment(logID: self.log.data.id, comments: self.comments)
						.padding()
						.background(Color.systemBackground)
				}
			}.listStyle(GroupedListStyle())

		}
//		.onAppear(perform: {
//			self.comments.comments.removeAll()
//			_ = self.comments.getComments(logID: String(self.log.data.id))
//		})
//		.onDisappear(perform: {
//			print("trigger")
//			self.comments.stop = true
//			self.comments.comments.removeAll()
//		})
		.navigationBarTitle("Detail Log", displayMode: .inline)
		.navigationBarItems(trailing:
			Button(action: {
				_ = self.comments.getComments(logID: String(self.log.data.id))
			}) {
				Image(systemName: "arrow.2.circlepath")
			}
		)
    }

	struct UserHeader: View {
		@ObservedObject var log: LogViewData

		var body: some View {
			VStack() {
				VStack() {
					HStack(alignment: .center) {
						WebImage(url: URL(string: self.log.data.user.avatar)!,
							 options: [.decodeFirstFrameOnly],
							 context: [.imageThumbnailPixelSize: CGSize(width: 140, height: 140)])
							.placeholder(Image("imagePlaceholder"))
							.resizable()
							.aspectRatio(contentMode: .fit)
							.frame(width: 70, height: 70)
							.cornerRadius(20)
							.clipped()
						VStack(alignment: .leading, spacing: 5) {
							if self.log.data.user.firstName != "" && self.log.data.user.lastName != "" {
								VStack(alignment: .leading) {
									Text("\(self.log.data.user.firstName) \(self.log.data.user.lastName)").font(.headline).bold()
									Text("@\(self.log.data.user.username)")
										.font(.subheadline)
								}
							} else {
								Text("@\(self.log.data.user.username)")
									.font(.headline)
							}

							HStack(spacing: 10) {
								Text("\(self.log.data.user.makerScore) 🏆")
								Text("\(self.log.data.user.streak) 🔥")
								Text("\(Int(self.log.data.user.weekTda)) 🏁")
							}
						}
						Spacer()
					}
					.frame(minWidth: 0, maxWidth: .infinity)

					HStack() {
						ProgressImg(done: self.log.data.done, inProgress: self.log.data.inProgress)
						EventImg(event: self.log.data.event ?? "")
						Text(self.log.data.content)
							.padding(10)
							.frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
							.cornerRadius(10)
							.lineLimit(200)
							.multilineTextAlignment(.leading)
							.fixedSize(horizontal: false, vertical: true)
					}
				}
				LinkPreview(links: LinkData(text: self.log.data.content))
			}
		}
	}

	struct AddComment: View {
		@EnvironmentObject var tabScreenData: TabScreenData
		@EnvironmentObject var login: LoginData
		@State var text: String = ""
		var logID: Int
		@ObservedObject var comments: CommentViewData
		var body: some View {
			HStack() {
				Button(action: {
					UIApplication.shared.endEditing()
					self.text = ""
				}) {
					Image(systemName: "xmark.square")
						.imageScale(.large)
						.foregroundColor(Color.blue)
				}
				TextField("Add a comment", text: $text)
				Button(action: {
					if self.login.isLoggedIn == false {
//						self.tabScreenData.showLogin = true
                        self.tabScreenData.presentSheet = .showLogin
                        self.tabScreenData.showSheet = true
					} else {
						self.comments.addComment(logID: self.logID, content: self.text)
					}
					self.text = ""
				}) {
					Text("Send")
				}
			}.keyboardObserving()
		}
	}

	struct CommentView: View {
		var comment: CommentElement

		var body: some View {
			VStack(alignment: .leading) {
				HStack() {
					WebImage(url: URL(string: comment.user.avatar)!,
						 options: [.decodeFirstFrameOnly],
						 context: [.imageThumbnailPixelSize: CGSize(width: 80, height: 80)])
						.placeholder(Image("imagePlaceholder"))
						.resizable()
						.aspectRatio(contentMode: .fit)
						.frame(width: 40, height: 40)
						.cornerRadius(20)
						.clipped()
					VStack() {
						if comment.user.firstName != "" && comment.user.lastName != "" {
							Text("\(comment.user.firstName) \(comment.user.lastName)").font(.subheadline).bold()
						}
						Text("@ \(comment.user.username)").font(.subheadline)
					}
					Spacer()
				}
				Text(comment.content)
					.fixedSize(horizontal: false, vertical: true)
					.frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
					.lineLimit(200)

			}
			.padding(10)
			.frame(minWidth: 0, maxWidth: .infinity)
		}
	}
}
