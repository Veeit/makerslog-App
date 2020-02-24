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
import Down

struct DiscussionsDetailView: View {
	@State var data: DiscussionModel

	let down = Down(markdownString: "## [Down](https://github.com/iwasrobbed/Down)")
    var body: some View {
		VStack() {
			ZStack(alignment: .top) {
				List() {
					VStack(alignment: .leading) {
						HStack(alignment: .top) {
							URLImage(URL(string: self.data.discussion.owner.avatar)!,
									 processors: [
										Resize(size: CGSize(width: 60, height: 60), scale: UIScreen.main.scale)
									],
									 placeholder: { _ in
										 Image("placeholer")
											 .resizable()
											 .aspectRatio(contentMode: .fit)
											 .clipped()
											 .cornerRadius(20)
											 .frame(width: 60, height: 60)
									 },
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
								.fixedSize(horizontal: false, vertical: true)
								.multilineTextAlignment(.leading)
								.layoutPriority(2)
						}

						//swiftlint:disable force_try

						Text(self.data.discussion.body)
							.layoutPriority(2)
							.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .leading)
							.padding([.bottom], 30)

						LinkPreview(links: LinkData(text: self.data.discussion.body))
					}.layoutPriority(2)

					if self.data.discussionResponse != nil {
						ForEach(self.data.discussionResponse!) { response in
							if response.parent_reply == nil {
								VStack(alignment: .leading) {
									ReplayView(response: response)
									LinkPreview(links: LinkData(text: response.body))

									VStack(alignment: .leading) {
										ForEach(self.data.getReplyReplys(reply: response).reversed()) { reply in
											VStack() {
												HStack(alignment: .top) {
													VStack() {
														URLImage(URL(string: "\(reply.owner.avatar)")!,
																 processors: [
																	Resize(size: CGSize(width: 45, height: 45), scale: UIScreen.main.scale)
															],
																 placeholder: { _ in
																	 Image("placeholer")
																		 .resizable()
																		 .aspectRatio(contentMode: .fit)
																		 .clipped()
																		 .cornerRadius(20)
																		 .frame(width: 45, height: 45)
																 },
																 content: {
																	$0.image
																		.resizable()
																		.aspectRatio(contentMode: .fit)
																		.clipped()
																		.cornerRadius(20)
																		.frame(width: 45, height: 45)
														})
															.frame(width: 45, height: 45)
													}

													VStack(alignment: .leading) {
														Divider()
														Text("\(reply.body)")
															.lineLimit(nil)
															.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .leading)
															.fixedSize(horizontal: false, vertical: true)
														HStack() {
															Text("@\(reply.owner.username)").bold()
															Text("👏 \(reply.praise)")
															Spacer()
														}
													}
												}.padding([.leading], 30)
												VStack() {
													LinkPreview(links: LinkData(text: reply.body))
												}
											}
										}
									}
								}
							}
						}
					} else {
						Text("loading ...!")
					}

				}.padding([.bottom], 60)

				VStack() {
					Spacer()
					VStack() {
						Divider()
						HStack() {
							TextField("Add a comment", text: self.$data.reply)
							Button(action: {
								self.data.postReply()
								self.data.reply = ""
							}) {
								Text("Send")
							}
						}
					}
					.keyboardObserving()
					.padding([.leading, .trailing, .bottom])
					.padding([.top], 0)
					.background(Color.systemBackground)
				}
			}
		}.onAppear(perform: {
			self.data.getDissucionsReplies()
		})
			.navigationBarTitle("\(self.data.discussion.title)", displayMode: .inline)
	}

	struct StringID: Identifiable {
		var id = UUID()
		var string: String

		init(string: String) {
			self.string = string
		}
	}

	func spriltby(toSplit: String, splitAt: Int) -> [StringID] {
		var currentString = ""
		var returnArray = [StringID]()
		var index = 0
		for char in toSplit {
			currentString.append(char)
			if index == splitAt {
				returnArray.append(StringID(string: currentString))
				currentString = ""
				index = 0
			}
			index += 1
		}
		return returnArray
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
