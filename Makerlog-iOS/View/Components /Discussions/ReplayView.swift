//
//  ReplayView.swift
//  iOS
//
//  Created by Veit Progl on 26.02.20.
//  Copyright © 2020 Veit Progl. All rights reserved.
//

import SwiftUI
import URLImage

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
