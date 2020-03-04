//
//  prductView.swift
//  Makerlog
//
//  Created by Veit Progl on 21.01.20.
//  Copyright © 2020 Veit Progl. All rights reserved.
//

import Foundation
import SwiftUI
import URLImage

struct ProductView: View {
	@State var data = ProductViewData()
	var projectID: String

	var body: some View {
		// swiftlint:disable empty_parentheses_with_trailing_closure
		VStack() {
			if self.data.products.count > 0 {
				ForEach(self.data.products) { product in
					HStack() {
						URLImage(URL(string: product.icon ?? "https://via.placeholder.com/500?text=No+icon")!,
								 processors: [ Resize(size: CGSize(width: 70, height: 70),
													  scale: UIScreen.main.scale)
											 ],
								 placeholder: { _ in
									Image("imagePlaceholder")
										.resizable()
										.aspectRatio(contentMode: .fit)
										.clipped()
										.cornerRadius(20)
										.frame(width: 70, height: 70)
								},
								 content: {
									$0.image
									.resizable()
									.aspectRatio(contentMode: .fit)
									.clipped()
									.cornerRadius(20)
									.frame(width: 70, height: 70)
								})
									.frame(width: 70, height: 70)

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
