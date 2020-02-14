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

struct DiscussionsDetailView: View {
	@State var data: DiscussionModel

    var body: some View {
		VStack() {
			List() {
				VStack(alignment: .leading) {
					HStack() {
						URLImage(URL(string: self.data.discussion.owner.avatar)!,
								 processors: [
									Resize(size: CGSize(width: 45, height: 45), scale: UIScreen.main.scale)
							],
								 content: {
									$0.image
										.resizable()
										.aspectRatio(contentMode: .fit)
										.clipped()
										.cornerRadius(20)
										.frame(width: 45, height: 45)
						}).frame(width: 45, height: 45)

						Text("\(self.data.discussion.title)")
							.font(.title)
							.bold()
							.frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
							.lineLimit(20000)
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
							ReplayView(response: response)
							ForEach(self.data.getReplyReplys(reply: response)) { reply in
								HStack() {
									VStack(alignment: .leading) {
										Text("\(reply.body)")
										Text("@\(reply.owner.username)").bold()
									}
									if reply.praise > 0 {
										Text("👏 \(reply.praise)")
									}
								}
							}
						}
					}
				} else {
					Text("Loading ...!")
				}

				HStack() {
					TextField("Add a comment", text: self.$data.reply)
					Button(action: {
						self.data.postReply()
						self.data.reply = ""
					}) {
						Text("Send")
					}
				}.keyboardObserving()
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

			VStack(alignment: .leading) {
				Text("\(response.body)").lineLimit(20000)

				HStack() {
					Text("@\(response.owner.username)").bold()
					Text("👏 \(response.praise)")
				}.padding([.top], 10)
			}
		}
	}
}
