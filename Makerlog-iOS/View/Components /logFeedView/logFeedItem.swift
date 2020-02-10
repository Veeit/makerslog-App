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

	var body: some View {
		let cmenu = ContextMenu {
			Button("Open") {  self.showDetailView.toggle() }
			Button("👏 \(self.log.log.praise)") {
				self.makerlogAPI.addPraise(log: self.log.log)
			}
		}

		return NavigationLink(destination: LogView(log: LogViewData(data: log.log),
												   comments: CommentViewData(logID: String(log.log.id))),
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

					Text(log.log.user.username).font(.subheadline).bold()
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
//					Text(log.event ?? "")
					EventImg(event: log.log.event ?? "")

					Text(log.log.content)
						.padding([.bottom], 15)
						.lineLimit(20)

					if log.log.praise > 0 {
						Spacer()
						Text("\(log.log.praise) 👏")
					}
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
			}
		}.onTapGesture {
			self.showDetailView.toggle()
		}
		.contextMenu(cmenu)
	}
}

//struct logFeedItem_Previews: PreviewProvider {
//    static var previews: some View {
//        logFeedItem()
//    }
//}
