//
//  ReplayView.swift
//  iOS
//
//  Created by Veit Progl on 26.02.20.
//  Copyright © 2020 Veit Progl. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI
import MDText

struct ReplayView: View {
	var response: DiscussionResponseElement

	var body: some View {
		HStack(alignment: .top) {
			VStack() {

				WebImage(url: URL(string: response.owner.avatar)!,
					 options: [.decodeFirstFrameOnly],
					 context: [.imageThumbnailPixelSize: CGSize(width: 120, height: 120)])
					.placeholder(Image("imagePlaceholder"))
					.resizable()
					.aspectRatio(contentMode: .fit)
					.frame(width: 60, height: 60)
					.clipped()
					.cornerRadius(20)
			}

			VStack(alignment: .leading) {
				MDText(markdown: "\(response.body)")
					.lineLimit(nil)
//					.fixedSize(horizontal: false, vertical: true)
//					.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .leading)

				HStack() {
					Text("@\(response.owner.username)").bold()
					Text("👏 \(response.praise)")
				}.padding([.top], 10)
			}.padding([.leading], 10)
		}.frame(minHeight: 70)
	}
}
