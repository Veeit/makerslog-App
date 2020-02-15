//
//  logFeedItem.swift
//  Makerlog
//
//  Created by Veit Progl on 01.02.20.
//  Copyright © 2020 Veit Progl. All rights reserved.
//

import SwiftUI
import URLImage

struct LogFeedItem: View {
	@ObservedObject var log: LogFeedItemData
	@State var showDetailView = false
	@EnvironmentObject var tabScreenData: TabScreenData
	@EnvironmentObject var makerlogAPI: MakerlogAPI
	@EnvironmentObject var login: LoginData

	var body: some View {
		let cmenu = ContextMenu {
			Button("Open") {  self.showDetailView.toggle() }
			Button("👏 \(self.log.log.praise)") {
				self.makerlogAPI.addPraise(log: self.log.log)
			}
			if self.log.log.user.username == login.meData.first?.username ?? "" {
				Button("Delete") {
					self.makerlogAPI.deleteItem.toggle()
				}
			}
		}

		return NavigationLink(destination: LogView(log: LogViewData(data: log.log)),
							  isActive: self.$showDetailView) {

			// swiftlint:disable empty_parentheses_with_trailing_closure
			VStack(alignment: .leading) {
				HStack() {
					URLImage(URL(string: log.log.user.avatar)!,
							 processors: [ Resize(size: CGSize(width: 40, height: 40), scale: UIScreen.main.scale) ],
							 content: {
						$0.image
						.resizable()
						.aspectRatio(contentMode: .fill)
						.clipped()
						.cornerRadius(20)
					})
						.frame(width: 40, height: 40)

					Text(self.log.log.user.firstName != "" && self.log.log.user.lastName != "" ? "\(self.log.log.user.firstName ) \(self.log.log.user.lastName)" : self.log.log.user.username)
						.font(.subheadline).bold()
					Spacer()

					Text("\(log.log.user.makerScore) 🏆")
				}

				HStack(alignment: .top) {
					if log.log.done {
						Image(systemName: "checkmark.circle").padding([.top], 5)
					}
					if log.log.inProgress {
						Image(systemName: "circle").padding([.top], 5)
					}
					EventImg(event: log.log.event ?? "")

					Text(log.log.content)
						.padding([.bottom], 15)
						.lineLimit(20)

//					if log.log.praise > 0 {
//						Spacer()
//						Text("\(log.log.praise) 👏")
//					}
				}

				if log.log.attachment != nil {
					URLImage(URL(string: log.log.attachment!)!,
							 content: {
						$0.image
						.resizable()
						.aspectRatio(contentMode: .fit)
						.clipped()
						.cornerRadius(7)
					})
				}

				HStack() {
					Spacer()
					Text("👏 \(self.log.log.praise)")
						.onTapGesture {
							self.makerlogAPI.addPraise(log: self.log.log)
						}
						.padding(4)
						.cornerRadius(6)
						.font(.footnote)

					Spacer()
					HStack() {
						Image(systemName: "arrow.turn.left.up").imageScale(.small)
						Text("Reply")
							.onTapGesture {
								self.showDetailView.toggle()
							}
							.padding(4)
							.cornerRadius(6)
							.font(.footnote)
					}
					Spacer()
					HStack() {
						Image(systemName: "link")
						Text("Copy link")
							.onTapGesture {
								let link = "https://getmakerlog.com/tasks/\(self.log.log.id)"
								UIPasteboard.general.string = link
							}
							.padding(4)
							.cornerRadius(6)
							.font(.footnote)
					}
					Spacer()
					if self.log.log.user.username == login.meData.first?.username ?? "" {
						HStack() {
							Image(systemName: "trash")
							Text("Delete")
								.onTapGesture {
									self.makerlogAPI.deleteItem.toggle()
								}
								.padding(4)
								.cornerRadius(6)
								.font(.footnote)
						}
					}
				}
			}
		}.onTapGesture {
			self.showDetailView.toggle()
		}
		.contextMenu(cmenu)
		.alert(isPresented: self.$makerlogAPI.deleteItem, content: anAlert)
	}

	func anAlert() -> Alert {
        let send = ActionSheet.Button.default(Text("Send")) { self.makerlogAPI.deleteLog(log: self.log.log) }

        // If the cancel label is omitted, the default "Cancel" text will be shown
		let cancel = ActionSheet.Button.cancel(Text("Abort")) { self.makerlogAPI.deleteItem.toggle() }

        return Alert(title: Text("Delete"),
					 message: Text("Sure that you want to delete this log ?"),
					 primaryButton: send,
					 secondaryButton: cancel)
    }
}

//struct logFeedItem_Previews: PreviewProvider {
//    static var previews: some View {
//        logFeedItem()
//    }
//}
