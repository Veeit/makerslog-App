//
//  LogView.swift
//  Makerlog
//
//  Created by Veit Progl on 21.01.20.
//  Copyright © 2020 Veit Progl. All rights reserved.
//

import Foundation
import SwiftUI
import URLImage

struct LogView: View {
    // swiftlint:disable empty_parentheses_with_trailing_closure
	var log: LogViewData
    @State var comments = CommentViewData()

    var body: some View {
		GeometryReader() { geometry in
			ScrollView() {
				VStack(alignment: .leading, spacing: 10) {
					HStack(alignment: .center) {
						URLImage(URL(string: self.log.data.user.avatar)!,
								 processors: [
									 Resize(size: CGSize(width: 70, height: 70), scale: UIScreen.main.scale)
								 ],
								 content: {
							$0.image
							.resizable()
							.aspectRatio(contentMode: .fill)
							.clipped()
							.cornerRadius(20)
						})
							.frame(width: 70, height: 70)
						VStack(alignment: .leading) {
							Text(self.log.data.user.username)
								.font(.headline).bold()

							HStack(spacing: 10) {
								Text("\(self.log.data.user.makerScore) 🏆")
								Text("\(self.log.data.user.streak) 🔥")
								Text("\(Int(self.log.data.user.weekTda)) 🏁")
							}
						}
						Spacer()
					}
					.padding(10)
					.frame(minWidth: 0, maxWidth: .infinity)
					.background(Color.primary.opacity(0.1))
					.cornerRadius(10)

					Text(self.log.data.content)
						.padding(10)
						.frame(minWidth: 0, maxWidth: .infinity)
						.background(Color.primary.opacity(0.1))
						.cornerRadius(10)
						.lineLimit(200)

					if self.log.data.projectSet.first?.id != nil {
						VStack(alignment: .leading) {
							Text("Products: ").bold()
							ForEach(self.log.data.projectSet) { project in
								VStack(alignment: .leading) {
									ProductView(data: ProductViewData(projectID: String(project.id)))
								}.padding([.bottom], 10)
							}
						}.padding([.top], 10)
					}

					if self.log.data.attachment != nil {
						URLImage(URL(string: self.log.data.attachment!)!,
							 content: {
						$0.image
						.resizable()
							.aspectRatio(contentMode: .fit)
						.clipped()
						.cornerRadius(7)
						.frame( maxWidth: geometry.size.width - 20)
						})
						.frame( maxWidth: geometry.size.width - 20)
					}

					VStack(alignment: .leading) {
						Text("Comments: ").bold()
						ForEach(self.comments.comments) { comment in
							VStack(alignment: .leading) {
								HStack() {
									URLImage(URL(string: comment.user.avatar)!,
											 processors: [
												Resize(size: CGSize(width: 40, height: 40),
												scale: UIScreen.main.scale)
											 ],
											 content: {
										$0.image
										.resizable()
										.aspectRatio(contentMode: .fill)
										.clipped()
										.cornerRadius(20)
									})
										.frame(width: 40, height: 40)
									Text(comment.user.username).font(.subheadline).bold()
									Spacer()
								}
								Text(comment.content)
									.lineLimit(200)

							}
							.padding(10)
							.frame(minWidth: 0, maxWidth: .infinity)
							.background(Color.primary.opacity(0.1))
							.cornerRadius(10)
						}
						AddComment()

					}
					Spacer()
				}.padding()
				.padding([.top], 50)
				.padding([.bottom], 150)

			}

		}
		.edgesIgnoringSafeArea(.top)
		.onAppear(perform: {
			self.comments.getComments(logID: String(self.log.data.id))
		})
    }

	struct AddComment: View {
		@State var text: String = ""
		var body: some View {
			VStack() {
				TextField("Add a comment", text: $text)
			}
		}
	}
}
