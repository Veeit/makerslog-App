//
//  prductView.swift
//  Makerlog
//
//  Created by Veit Progl on 21.01.20.
//  Copyright © 2020 Veit Progl. All rights reserved.
//

import Foundation
import SwiftUI
import SDWebImageSwiftUI

struct ProductView: View {
	@State var data = ProductViewData()
	var projectID: String

	var body: some View {
		// swiftlint:disable empty_parentheses_with_trailing_closure
		VStack() {
			if self.data.products.count > 0 {
				ForEach(self.data.products) { product in
					HStack() {
							WebImage(url: URL(string: product.icon ?? "https://via.placeholder.com/500?text=No+icon")!,
								 options: [.decodeFirstFrameOnly],
								 context: [.imageThumbnailPixelSize: CGSize(width: 140, height: 140)])
							.placeholder(Image("imagePlaceholder"))
							.resizable()
							.aspectRatio(contentMode: .fit)
							.frame(width: 70, height: 70)
							.clipped()
							.cornerRadius(20)
						VStack(alignment: .leading) {
							Text(product.name)
								.bold()
							Text(product.productDescription ?? "")
						}
						Spacer()
					}
					.padding([.leading, .trailing], 10)
					.frame(minWidth: 0, maxWidth: .infinity)
				}
			} else {
				Text("no product set 🤷🏻‍♂️")
				.padding([.leading, .trailing], 10)
				.frame(minWidth: 0, maxWidth: .infinity)
			}
		}.onAppear(perform: {
			self.data.getRelatedProject(projectID: self.projectID)
		})
	}
}
