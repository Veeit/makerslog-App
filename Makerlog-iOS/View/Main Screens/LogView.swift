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
import KeyboardObserving
import MDText

struct LogView: View {
    // swiftlint:disable empty_parentheses_with_trailing_closure
	@ObservedObject var log: LogViewData
	@EnvironmentObject var comments: CommentViewData
	@EnvironmentObject var makerlogAPI: MakerlogAPI
	@State var showDetailView = false

	@State var userComments = Comment()
	let defaultAvartar = "https://gravatar.com/avatar/d3df4c9fe1226f2913c9579725c1e4aa?s=150&d=mm&r=pg"

    var body: some View {
		GeometryReader() { geometry in
			ZStack() {
				List() {
					VStack() {
						HStack(alignment: .center) {
							URLImage(URL(string: self.log.data.user.avatar)!,
									 processors: [
										 Resize(size: CGSize(width: 70, height: 70), scale: UIScreen.main.scale)
									 ],
									 placeholder: Image("placeholder"),
									 content: {
								$0.image
								.resizable()
								.aspectRatio(contentMode: .fill)
								.clipped()
								.cornerRadius(20)
							})
								.frame(width: 70, height: 70)
							VStack(alignment: .leading, spacing: 5) {
								if self.log.data.user.firstName != "" && self.log.data.user.lastName != "" {
									VStack(alignment: .leading) {
										Text("\(self.log.data.user.firstName) \(self.log.data.user.lastName)").font(.headline).bold()
										Text("@\(self.log.data.user.username)")
											.font(.subheadline)
									}
								} else {
									Text("@\(self.log.data.user.username)")
										.font(.headline)
								}

								HStack(spacing: 10) {
									Text("\(self.log.data.user.makerScore) 🏆")
									Text("\(self.log.data.user.streak) 🔥")
									Text("\(Int(self.log.data.user.weekTda)) 🏁")
								}
							}
							Spacer()
						}
						.frame(minWidth: 0, maxWidth: .infinity)

						HStack() {
							ProgressImg(done: self.log.data.done, inProgress: self.log.data.inProgress)
							EventImg(event: self.log.data.event ?? "")
//							Text(self.log.data.content)
//								.padding(10)
//								.frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
//								.cornerRadius(10)
//								.lineLimit(200)
//								.multilineTextAlignment(.leading)
//								.fixedSize(horizontal: false, vertical: true)
							MDText(markdown: self.log.data.content)
								.padding(10)
								.frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
								.cornerRadius(10)
								.lineLimit(200)
								.multilineTextAlignment(.leading)
								.fixedSize(horizontal: false, vertical: true)
						}
						
					}
					LogInteractive(log: self.log, showDetailView: self.$showDetailView).offset(x: -10)

					if self.log.data.projectSet.first?.id != nil {
						Section(header: Text("Products:")) {
							ForEach(self.log.data.projectSet) { project in
								VStack(alignment: .leading) {
									ProductView(data: ProductViewData(projectID: String(project.id)))
								}.padding([.top, .bottom], 10)
							}
						}
					}

					Section(header: Text("Comments: ") ) {
						ForEach(self.comments.comments) { comment in
							CommentView(comment: comment)
						}
					}

					if self.log.data.attachment != nil {
						Section() {
							URLImage(URL(string: self.log.data.attachment!)!,
								 placeholder: Image("placeholder"),
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
					}
				}.padding([.bottom], 60)

				VStack() {
					Spacer()
					AddComment(logID: self.log.data.id, comments: self.comments)
						.padding()
						.background(Color.systemBackground)
				}
			}.listStyle(GroupedListStyle())

		}
		.onAppear(perform: {
			self.comments.comments.removeAll()
			self.comments.getComments(logID: String(self.log.data.id))
			print(self.userComments)
		})
		.navigationBarTitle("Detail Log", displayMode: .inline)
    }

	struct AddComment: View {
		@State var text: String = ""
		var logID: Int
		@ObservedObject var comments: CommentViewData
		var body: some View {
			HStack() {
				TextField("Add a comment", text: $text)
				Button(action: {
					self.comments.addComment(logID: self.logID, content: self.text)
					self.text = ""
				}) {
					Text("Send")
				}
			}.keyboardObserving()
		}
	}

	struct CommentView: View {
		var comment: CommentElement

		var body: some View {
			VStack(alignment: .leading) {
				HStack() {
					URLImage(URL(string: comment.user.avatar)!,
							 processors: [
								Resize(size: CGSize(width: 40, height: 40),
								scale: UIScreen.main.scale)
							 ],
							 placeholder: Image("placeholder"),
							 content: {
						$0.image
						.resizable()
						.aspectRatio(contentMode: .fill)
						.clipped()
						.cornerRadius(20)
					})
						.frame(width: 40, height: 40)
					VStack() {
						if comment.user.firstName != "" && comment.user.lastName != "" {
							Text("\(comment.user.firstName) \(comment.user.lastName)").font(.subheadline).bold()
						}
						Text("@ \(comment.user.username)").font(.subheadline)
					}
					Spacer()
				}
				Text(comment.content)
					.fixedSize(horizontal: false, vertical: true)
					.frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
					.lineLimit(200)

			}
			.padding(10)
			.frame(minWidth: 0, maxWidth: .infinity)
		}
	}
}
