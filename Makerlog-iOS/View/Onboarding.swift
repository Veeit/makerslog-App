//
//  Onboarding.swift
//  iOS
//
//  Created by Veit Progl on 24.02.20.
//  Copyright © 2020 Veit Progl. All rights reserved.
//

import SwiftUI
import Pages

struct Page: Identifiable {
	var id = UUID().uuidString
	var title: String
	var subTitle: String
	var text: String
	var img: String
}

struct Onboarding: View {
	@EnvironmentObject var tabBata: TabScreenData
	var pages = [Page(title: "LogBot",
					  subTitle: "a nativ makerlog client",
					  text: """
The makerlog comunity is one of the biggest comunity of makers.
We love to share and ship things !
""",
					  img: ""),
				 Page(title: "Logs!",
						  subTitle: "LogBot can log your daily tasks",
						  text: """
Every maker loves to shere this work, with logbot you can shere you tasks without any touble!
""",
						  img: ""),
				 Page(title: "Log your tasks",
							  subTitle: "Discussions!",
							  text: """
Start a new discussion about any topic and discuss with other makers.
And shere your opinon about other topics with the comunity.
""",
							  img: "")]

    @State var index: Int = 0

	// swiftlint:disable empty_parentheses_with_trailing_closure multiple_closures_with_trailing_closure
    var body: some View {
		ModelPages(pages, currentPage: self.$index) { _, data in
			VStack() {
				Spacer()
				Text(data.title).font(Font.title).bold()
				Text(data.subTitle).font(Font.headline).bold().padding([.bottom], 15)
				Text(data.text)
				Spacer()
				Button(action: {
					if self.pages.count - 1 > self.index {
						self.index += 1
					} else {
						self.tabBata.setOnbaording()
						self.tabBata.showOnboarding = false
					}
				}) {
					Text(self.pages.count - 1 == self.index ? "Close": "Next")
						.bold()
						.foregroundColor(Color.white)
				}
				.frame(minWidth: 0, maxWidth: .infinity, minHeight: 40)
				.background(Color.blue)
				.cornerRadius(10)

				if self.index != 0 {
					Button(action: {
						if 0 < self.index {
							self.index -= 1
						}
					}) {
						Text("Prev")
					}
				}
			}.padding(50)
		}.background(Color.systemBackground)
	}
}

struct Onboarding_Previews: PreviewProvider {
    static var previews: some View {
        Onboarding()
    }
}
