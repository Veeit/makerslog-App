//
//  DiscussionsView.swift
//  iOS
//
//  Created by Veit Progl on 13.02.20.
//  Copyright © 2020 Veit Progl. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct DiscussionsView: View {
	@EnvironmentObject var data: MakerlogAPI
    @EnvironmentObject var device: Device
    
    var body: some View {
		//swiftlint:disable empty_parentheses_with_trailing_closure
		NavigationView() {
			List() {
				if self.data.discussions != nil {
					ForEach(self.data.discussions!) { discussion in
						NavigationLink(destination: DiscussionsDetailView(data: DiscussionData(discussion: discussion))) {
							HStack(alignment: .top) {
								WebImage(url: URL(string: discussion.owner.avatar)!,
									 options: [.decodeFirstFrameOnly],
									 context: [.imageThumbnailPixelSize: CGSize(width: 120, height: 120)])
									.placeholder(Image("imagePlaceholder"))
									.resizable()
									.aspectRatio(contentMode: .fit)
									.frame(width: 60, height: 60)
									.clipped()
									.cornerRadius(20)

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
			}
			.navigationBarTitle("Discussion")
			.navigationBarItems(trailing:
				Button(action: {
					self.data.getDissucions()
				}) {
					Image(systemName: "arrow.2.circlepath")
				}
			)
		}.ipadNavigationView(oriantation: device.isLandscape)
	}
}

struct DiscussionsView_Previews: PreviewProvider {
    static var previews: some View {
        DiscussionsView()
    }
}
