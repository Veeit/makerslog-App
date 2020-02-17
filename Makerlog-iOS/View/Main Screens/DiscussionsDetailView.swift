//
//  DiscussionsDetailView.swift
//  iOS
//
//  Created by Veit Progl on 13.02.20.
//  Copyright © 2020 Veit Progl. All rights reserved.
//

import SwiftUI
import URLImage
import KeyboardObserving
import SwiftUIX

struct DiscussionsDetailView: View {
	@State var data: DiscussionModel

    var body: some View {
		VStack() {
			ZStack() {
				List() {
					VStack(alignment: .leading) {
						HStack() {
							URLImage(URL(string: self.data.discussion.owner.avatar)!,
									 processors: [
										Resize(size: CGSize(width: 60, height: 60), scale: UIScreen.main.scale)
								],
									 content: {
										$0.image
											.resizable()
											.aspectRatio(contentMode: .fit)
											.clipped()
											.cornerRadius(20)
											.frame(width: 60, height: 60)
							}).frame(width: 60, height: 60)

							Text("\(self.data.discussion.title)")
								.font(.title)
								.bold()
								.lineLimit(nil)
								.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .leading)
								.multilineTextAlignment(.leading)
						}
						Text("\(self.data.discussion.body)")
							.lineLimit(20000)
							.layoutPriority(2)
							.padding([.bottom], 30)
					}.layoutPriority(2)

					if self.data.discussionResponse != nil {
						ForEach(self.data.discussionResponse!) { response in
							if response.parent_reply == nil {
								VStack(alignment: .leading) {
									ReplayView(response: response)
									VStack(alignment: .leading) {
										ForEach(self.data.getReplyReplys(reply: response)) { reply in
											HStack(alignment: .top) {
//													Disvider()
												VStack() {
//														Image(systemName: "arrow.uturn.left.circle")
													URLImage(URL(string: "\(reply.owner.avatar)")!,
															 processors: [
																Resize(size: CGSize(width: 30, height: 30), scale: UIScreen.main.scale)
														],
															 content: {
																$0.image
																	.resizable()
																	.aspectRatio(contentMode: .fit)
																	.clipped()
																	.cornerRadius(20)
																	.frame(width: 45, height: 45)
													})
														.frame(width: 30, height: 30)
														.padding(10)
												}

												VStack(alignment: .leading) {
													Text("\(reply.body)")
														.lineLimit(nil)
														.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .leading)
													HStack() {
														Text("@\(reply.owner.username)").bold()
														Text("👏 \(reply.praise)")
														Spacer()
													}
													Divider()
												}
											}
										}
									}
									.padding([.leading], 30)
								}
							}
						}
					} else {
						Text("loading ...!")
					}

				}.padding([.bottom], 60)

				VStack() {
					Spacer()
					HStack() {
						TextField("Add a comment", text: self.$data.reply)
						Button(action: {
							self.data.postReply()
							self.data.reply = ""
						}) {
							Text("Send")
						}
					}
					.keyboardObserving()
					.padding()
					.background(Color.systemBackground)
				}
			}
		}.onAppear(perform: {
			self.data.getDissucionsReplies()
		})
			.navigationBarTitle("\(self.data.discussion.title)", displayMode: .inline)
	}
}

struct ReplayView: View {
	var response: DiscussionResponseElement

	var body: some View {
		HStack(alignment: .top) {
			VStack() {
				URLImage(URL(string: response.owner.avatar)!,
						 processors: [
							Resize(size: CGSize(width: 60, height: 60), scale: UIScreen.main.scale)
					],
						 content: {
							$0.image
								.resizable()
								.aspectRatio(contentMode: .fit)
								.clipped()
								.cornerRadius(20)
								.frame(width: 60, height: 60)
				}).frame(width: 60, height: 60)
			}

			VStack(alignment: .leading) {
				Text("\(response.body)")
					.lineLimit(nil)
					.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .leading)

				HStack() {
					Text("@\(response.owner.username)").bold()
					Text("👏 \(response.praise)")
				}.padding([.top], 10)
			}
		}
	}
}
