//
//  NotificationsView.swift
//  iOS
//
//  Created by Veit Progl on 05.02.20.
//  Copyright © 2020 Veit Progl. All rights reserved.
//

import SwiftUI
//import URLImage
import SDWebImageSwiftUI

struct NotificationsView: View {
	@EnvironmentObject var data: MakerlogAPI

	// swiftlint:disable multiple_closures_with_trailing_closure empty_parentheses_with_trailing_closure
    var body: some View {
		VStack() {
			RefreshableNavigationView(title: "Notification", action: {
				self.data.getNotifications()
			}, isDone: self.$data.notificationisDone) {
				if self.data.notification != nil {
					ForEach(self.data.notification!) { notification in
						HStack() {
							WebImage(url: URL(string: notification.actor.avatar)!,
								 options: [.decodeFirstFrameOnly],
								 context: [.imageThumbnailPixelSize : CGSize(width: 120, height: 120)])
							.placeholder(Image("imagePlaceholder"))
							.resizable()
							.aspectRatio(contentMode: .fit)
							.frame(width: 60, height: 60)
							.clipped()
							.cornerRadius(20)
							VStack(alignment: .leading) {
								Text("\((notification.actor.username))").bold()
								if notification.target != nil {
									TargetView(target: notification.target!)
								}
								Text("\((notification.verb))").font(.subheadline)
							}
						}
					}
				}
			}.onAppear(perform: {
				self.data.getNotifications()
			})
			.navigationViewStyle(StackNavigationViewStyle())
		}
	}

	struct TargetView: View {
		var target: Target
		var body: some View {
			if target.title != nil {
				return Text("✍️ \(target.title!)")
			} else if target.content != nil {
				return Text("\(target.praise ?? 0)👏 \(target.content!)")
			} else {
				return Text(" ").font(Font.system(size: 1))
			}
		}
	}
}

struct NotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsView()
    }
}
