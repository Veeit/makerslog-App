//
//  DiscussionsDetailView.swift
//  iOS
//
//  Created by Veit Progl on 13.02.20.
//  Copyright © 2020 Veit Progl. All rights reserved.
//

import SwiftUI
import URLImage

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
							.frame(minWidth: 0, maxWidth: .infinity)
							.lineLimit(20000)
					}
					Text("\(self.data.discussion.body)")
						.lineLimit(20000)
				}.padding([.bottom], 30)

				if self.data.discussionResponse != nil {
					ForEach(self.data.discussionResponse!) { response in
						if response.parent_reply == nil {
							ReplayView(response: response)
						}
					}
				} else {
					Text("Loading ...!")
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
		HStack() {
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
				Text("\(response.body)").lineLimit(2)

				HStack() {
					Text("@\(response.owner.username)")
					Text("👏 \(response.praise)")
						.lineLimit(20000)
				}.padding([.top], 10)
			}
		}
	}
}
