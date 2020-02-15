//
//  DiscussionsView.swift
//  iOS
//
//  Created by Veit Progl on 13.02.20.
//  Copyright © 2020 Veit Progl. All rights reserved.
//

import SwiftUI
import URLImage

struct DiscussionsView: View {
	@EnvironmentObject var data: MakerlogAPI

    var body: some View {
		NavigationView() {
			List() {
				if self.data.discussions != nil {
					ForEach(self.data.discussions!) { discussion in
						NavigationLink(destination: DiscussionsDetailView(data: DiscussionModel(discussion: discussion))) {
							HStack(alignment: .top) {
								URLImage(URL(string: discussion.owner.avatar)!,
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
									Text("\(discussion.title)").bold()
									Text("\(discussion.body)").lineLimit(2)

									HStack() {
										Text("@\(discussion.owner.username)")
										Text("🗣 \(discussion.reply_count ?? 0)")
									}.padding([.top], 10)
								}
							}
						}
					}
				} else {
					Text("loading ...")
				}

			}.onAppear(perform: {
				self.data.getDissucions()
			})
			.navigationBarTitle("Discussion")
		}
	}
}

struct DiscussionsView_Previews: PreviewProvider {
    static var previews: some View {
        DiscussionsView()
    }
}
