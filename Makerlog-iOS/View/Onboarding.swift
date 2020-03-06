//
//  Onboarding.swift
//  iOS
//
//  Created by Veit Progl on 24.02.20.
//  Copyright © 2020 Veit Progl. All rights reserved.
//

import SwiftUI

struct Page: Identifiable {
	var id = UUID().uuidString
	var title: String
	var subTitle: String
	var text: String
	var img: String
}

struct Onboarding: View {
	@EnvironmentObject var tabData: TabScreenData
	@EnvironmentObject var login: LoginData

    @State var index: Int = 0

	// swiftlint:disable empty_parentheses_with_trailing_closure multiple_closures_with_trailing_closure
    var body: some View {
		ScrollView() {
			Group() {
				HStack() {
					Group() {
						Text("LogBot").font(.largeTitle).bold().foregroundColor(Color.green) +
						Text(" a native makerlog client").font(.largeTitle).bold()
					}
				}
				.lineLimit(nil)
				.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .leading)
				.fixedSize(horizontal: false, vertical: true)
				.multilineTextAlignment(.leading)
				.layoutPriority(2)

				Text("""
				The Makerlog community is one of the largest communities of creators.
				We love to share and send things!
				""")
					.font(.headline)
					.lineLimit(nil)
					.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .leading)
					.fixedSize(horizontal: false, vertical: true)
					.multilineTextAlignment(.leading)
					.layoutPriority(2)
			}.padding([.bottom], 20)
			Group() {
				HStack(alignment: .top) {
					Image(systemName: "book")
						.resizable()
						.aspectRatio(contentMode: .fit)
						.clipped()
						.frame(width: 45, height: 45, alignment: .leading)
						.padding([.trailing], 10)
						.foregroundColor(Color.green)

					VStack(alignment: .leading) {
						Text("Explore the logs").font(.title).bold()
						Text("You can explore every log, from every single creator")
							.font(.headline)
							.lineLimit(nil)
							.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .leading)
							.fixedSize(horizontal: false, vertical: true)
							.multilineTextAlignment(.leading)
							.layoutPriority(2)
					}
				}
			}.padding([.bottom], 15)
			Group() {
				HStack(alignment: .top) {
					Image(systemName: "paperplane.fill")
						.resizable()
						.aspectRatio(contentMode: .fit)
						.clipped()
						.frame(width: 45, height: 45, alignment: .leading)
						.padding([.trailing], 10)
						.foregroundColor(Color.green)

					VStack(alignment: .leading) {
						Text("Log your daily tasks").font(.title).bold()
						Text("Every creator loves to share this work, with the Logbot you can do this without any effort!")
							.font(.headline)
							.lineLimit(nil)
							.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .leading)
							.fixedSize(horizontal: false, vertical: true)
							.multilineTextAlignment(.leading)
							.layoutPriority(2)
					}
				}
			}.padding([.bottom], 15)
			Group() {
				HStack(alignment: .top) {
					Image(systemName: "person.3.fill")
						.resizable()
						.aspectRatio(contentMode: .fit)
						.clipped()
						.frame(width: 45, height: 45, alignment: .leading)
						.padding([.trailing], 10)
						.foregroundColor(Color.green)

					VStack(alignment: .leading) {
						Text("Discussions for everthing!").font(.title).bold()
						Text("Start a new discussion on any topic you like and discuss with other creators. And share your opinion on other topics with the community.")
							.font(.headline)
							.lineLimit(nil)
							.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .leading)
							.fixedSize(horizontal: false, vertical: true)
							.multilineTextAlignment(.leading)
							.layoutPriority(2)
					}
				}
			}.padding([.bottom], 20)
			Group() {
				Button(action: {
					if self.login.acceptedDatapolicy == false {
						self.login.showDatapolicyAlert = true
					} else {
						self.login.login()
						self.tabData.setOnbaording()
						self.tabData.showOnboarding = false
					}
				}) {
					Text("Login with makerlog")
						.bold()
						.foregroundColor(Color.white)
						.frame(minWidth: 0, maxWidth: 300, minHeight: 40)
						.background(Color.blue)
						.cornerRadius(10)
				}

				Button(action: {
					self.tabData.setOnbaording()
					self.tabData.showOnboarding = false
				}) {
					Text("Skip login")
				}.padding([.top], 20)
			}
		}
		.frame(minWidth: 0, maxWidth: .infinity)
		.padding([.leading, .trailing], 20)
		.padding([.bottom, .top], 10)
		.background(Color.systemBackground)
		.edgesIgnoringSafeArea(.bottom)
	}
}

struct Onboarding_Previews: PreviewProvider {
    static var previews: some View {
        Onboarding()
    }
}
