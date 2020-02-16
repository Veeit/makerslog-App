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
	var log: LogViewData
	@EnvironmentObject var tabScreenData: TabScreenData
	@EnvironmentObject var makerlogAPI: MakerlogAPI
	@EnvironmentObject var login: LoginData
	@State var showDetailView = false

	var body: some View {
		let cmenu = ContextMenu {
			Button("Open") {  self.showDetailView.toggle() }
			Button("👏 \(self.log.data.praise)") {
				self.makerlogAPI.addPraise(log: self.log.data)
			}
			if self.log.data.user.username == login.meData.first?.username ?? "" {
				Button("Delete") {
					self.makerlogAPI.deleteItem.toggle()
				}
			}
		}

		return NavigationLink(destination: LogView(log: log),
							  isActive: self.$showDetailView) {

			// swiftlint:disable empty_parentheses_with_trailing_closure
			VStack(alignment: .leading) {
				HStack() {
					URLImage(URL(string: log.data.user.avatar)!,
							 processors: [ Resize(size: CGSize(width: 40, height: 40), scale: UIScreen.main.scale) ],
							 content: {
						$0.image
						.resizable()
						.aspectRatio(contentMode: .fill)
						.clipped()
						.cornerRadius(20)
					})
						.frame(width: 40, height: 40)

					Text(self.log.data.user.firstName != "" && self.log.data.user.lastName != "" ? "\(self.log.data.user.firstName ) \(self.log.data.user.lastName)" : self.log.data.user.username)
						.font(.subheadline).bold()
					Spacer()

					Text("\(log.data.user.makerScore) 🏆")
				}

				HStack(alignment: .top) {
					if log.data.done {
						Image(systemName: "checkmark.circle").padding([.top], 5)
					}
					if log.data.inProgress {
						Image(systemName: "circle").padding([.top], 5)
					}
					EventImg(event: log.data.event ?? "")

					Text(log.data.content)
						.padding([.bottom], 15)
						.lineLimit(20)

//					if log.log.praise > 0 {
//						Spacer()
//						Text("\(log.log.praise) 👏")
//					}
				}

				if log.data.attachment != nil {
					VStack(alignment: .center) {
						URLImage(URL(string: log.data.attachment!)!,
								 content: {
							$0.image
							.resizable()
							.aspectRatio(contentMode: .fit)
							.clipped()
							.cornerRadius(7)
							.frame(maxHeight: 300)
						}).frame(maxHeight: 300)
					}.frame(minWidth: 0, maxWidth: .infinity)
				}

				LogInteractive(log: log, showDetailView: self.$showDetailView)
			}
		}.onTapGesture {
			self.showDetailView.toggle()
		}
		.contextMenu(cmenu)
		.alert(isPresented: self.$makerlogAPI.deleteItem, content: anAlert)
	}

	func anAlert() -> Alert {
        let send = ActionSheet.Button.default(Text("Send")) { self.makerlogAPI.deleteLog(log: self.log.data) }

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
