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
						Text(" a nativ makerlog client").font(.largeTitle).bold()
					}
				}
				.lineLimit(nil)
				.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .leading)
				.fixedSize(horizontal: false, vertical: true)
				.multilineTextAlignment(.leading)
				.layoutPriority(2)
				
				Text("""
				The makerlog comunity is one of the biggest comunity of makers.
				We love to share and ship things !
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
						.frame(width: 60, height: 60, alignment: .leading)
					VStack(alignment: .leading) {
						Text("Browse the log feed").font(.title).bold()
						Text("You can browse all logs from every single maker")
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
				HStack(alignment: .top) {
					Image(systemName: "paperplane.fill")
						.resizable()
						.aspectRatio(contentMode: .fit)
						.clipped()
						.frame(width: 60, height: 60, alignment: .leading)
					VStack(alignment: .leading) {
						Text("Log your daily tasks").font(.title).bold()
						Text("Every maker loves to shere this work, with logbot you can shere you tasks without any touble!")
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
				HStack(alignment: .top) {
					Image(systemName: "person.3.fill")
						.resizable()
						.aspectRatio(contentMode: .fit)
						.clipped()
						.frame(width: 60, height: 60, alignment: .leading)
					VStack(alignment: .leading) {
						Text("Discussions for everthing!").font(.title).bold()
						Text("Start a new discussion about any topic and discuss with other makers. And shere your opinon about other topics with the comunity.")
							.font(.headline)
							.lineLimit(nil)
							.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .leading)
							.fixedSize(horizontal: false, vertical: true)
							.multilineTextAlignment(.leading)
							.layoutPriority(2)
					}
				}
			}.padding([.bottom], 30)
			Group() {
				Button(action: {
					self.login.login()
					self.tabData.setOnbaording()
					self.tabData.showOnboarding = false
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
		.background(Color.systemBackground)
	}
}

struct Onboarding_Previews: PreviewProvider {
    static var previews: some View {
        Onboarding()
    }
}
