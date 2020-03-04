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
import SwiftUIX
import Down
import MDText

struct AttributedText: UIViewRepresentable {
    var attributedText: NSAttributedString

    init(_ attributedText: NSAttributedString) {
        self.attributedText = attributedText
    }

    func makeUIView(context: Context) -> UITextView {
        return UITextView()
    }

    func updateUIView(_ label: UITextView, context: Context) {
        label.attributedText = attributedText
    }
}

//usage:

struct DiscussionsDetailView: View {
	@State var data: DiscussionData
	@EnvironmentObject var tabScreenData: TabScreenData
	@EnvironmentObject var login: LoginData

	//swiftlint:disable empty_parentheses_with_trailing_closure multiple_closures_with_trailing_closure
    var body: some View {
		VStack() {
			ZStack(alignment: .top) {
				ScrollView(.vertical, showsIndicators: true) {
					VStack(alignment: .leading) {
						HStack(alignment: .top) {
							URLImage(URL(string: self.data.discussion.owner.avatar)!,
									 processors: [
										Resize(size: CGSize(width: 60, height: 60), scale: UIScreen.main.scale)
									],
									 placeholder: { _ in
										 Image("imagePlaceholder")
											 .resizable()
											 .aspectRatio(contentMode: .fit)
											 .clipped()
											 .cornerRadius(20)
											 .frame(width: 60, height: 60)
									 },
									 content: {
										$0.image
											.resizable()
											.aspectRatio(contentMode: .fit)
											.clipped()
											.cornerRadius(20)
											.frame(width: 60, height: 60)
							}).frame(width: 60, height: 60)

							Text("\(self.data.discussion.title)")
								.font(.title)
								.bold()
								.lineLimit(nil)
								.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .leading)
								.fixedSize(horizontal: false, vertical: true)
								.multilineTextAlignment(.leading)
								.layoutPriority(2)
						}

//						Text(self.data.discussion.body)
//							.layoutPriority(2)
//							.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .leading)
//							.padding([.bottom], 30)

//						LinkPreview(links: LinkData(text: self.data.discussion.body))
						//swiftlint:disable force_try
//						AttributedText( try! Down(markdownString: self.data.discussion.body).toAttributedString())
//							.layoutPriority(2)
//							.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .leading)
//							.fixedSize(horizontal: false, vertical: true)
//							.padding([.bottom], 30)
						MDText(markdown: self.data.discussion.body)
							.layoutPriority(2)
//							.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .leading)
							.padding([.bottom], 30)
							.fixedSize(horizontal: false, vertical: true)
						Divider()
					}

					VStack() {
						if self.data.discussionResponse != nil {
							ForEach(self.data.discussionResponse!) { response in
								if response.parent_reply == nil {
									VStack(alignment: .leading) {
										ReplayView(response: response)
										Divider()
	//									LinkPreview(links: LinkData(text: response.body))

										VStack(alignment: .leading) {
											ForEach(self.data.getReplyReplys(reply: response).reversed()) { reply in
												VStack() {
													HStack(alignment: .top) {
														VStack() {
															URLImage(URL(string: "\(reply.owner.avatar)")!,
																	 processors: [
																		Resize(size: CGSize(width: 45, height: 45), scale: UIScreen.main.scale)
																],
																	 placeholder: { _ in
																		 Image("imagePlaceholder")
																			 .resizable()
																			 .aspectRatio(contentMode: .fit)
																			 .clipped()
																			 .cornerRadius(20)
																			 .frame(width: 45, height: 45)
																	 },
																	 content: {
																		$0.image
																			.resizable()
																			.aspectRatio(contentMode: .fit)
																			.clipped()
																			.cornerRadius(20)
																			.frame(width: 45, height: 45)
															})
																.frame(width: 45, height: 45)
														}

														VStack(alignment: .leading) {
															MDText(markdown: "\(reply.body)")
																.lineLimit(nil)
																.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .leading)
																.fixedSize(horizontal: false, vertical: true)
															HStack() {
																Text("@\(reply.owner.username)").bold()
																Text("👏 \(reply.praise)")
																Spacer()
															}
															Divider()

														}.padding([.leading], 10)
													}.padding([.leading], 30)
	//												VStack() {
	//													LinkPreview(links: LinkData(text: reply.body))
	//												}
												}
											}
										}
									}.padding([.top], 5)
								}
							}
						} else {
							Text("loading ...!")
						}
					}

				}.padding().padding([.bottom], 60)

				VStack() {
					Spacer()
					VStack() {
						Divider()
						HStack() {
							Button(action: {
								UIApplication.shared.endEditing()
								self.data.reply = ""
							}) {
								Image(systemName: "xmark.square")
									.imageScale(.large)
									.foregroundColor(Color.blue)
							}
							TextField("Add a comment", text: self.$data.reply)
							Button(action: {
								if self.login.isLoggedIn == false {
									self.tabScreenData.showLogin = true
								} else {
									self.data.postReply()
								}
								self.data.reply = ""
							}) {
								Text("Send")
							}
						}
					}
					.keyboardObserving()
					.padding([.leading, .trailing, .bottom])
					.padding([.top], 0)
					.background(Color.systemBackground)
				}
			}
		}.onAppear(perform: {
			self.data.getDissucionsReplies()
		})
			.navigationBarTitle("\(self.data.discussion.title)", displayMode: .inline)
	}

}
