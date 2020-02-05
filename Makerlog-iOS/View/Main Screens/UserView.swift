//
//  UserView.swift
//  Makerlog
//
//  Created by Veit Progl on 01.02.20.
//  Copyright © 2020 Veit Progl. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI
import QGrid

struct UserView: View {
	@ObservedObject var login: LoginData
    let defaultAvartar = "https://gravatar.com/avatar/d3df4c9fe1226f2913c9579725c1e4aa?s=150&d=mm&r=pg"

	var body: some View {
		// swiftlint:disable empty_parentheses_with_trailing_closure
		VStack(spacing: 30) {

//			Text(String("\(self.login.meData.first)"))

			HStack(alignment: .center) {
				WebImage(url: URL(string: self.login.meData.first?.avatar ?? defaultAvartar))
					.resizable()
					.scaledToFill()
					.frame(width: 130, height: 130, alignment: .center)
					.cornerRadius(100)
				Spacer()
				VStack() {
					Text(self.login.userName)
							.font(.headline).bold()

					HStack( spacing: 10) {

						Text("\(self.login.meData.first?.makerScore ?? 0) 🏆")
						Text("\(self.login.meData.first?.streak ?? 0) 🔥")
						Text("\(Int(self.login.meData.first?.weekTda ?? 0)) 🏁")
					}
				}
			}
			.padding(20)
			.frame(minWidth: 0, maxWidth: .infinity)
			.background(Color.primary.opacity(0.1))
			.cornerRadius(10)

			VStack() {
				Text(self.login.meData.first?.meDescription ?? "no desciption set")
			}

			VStack(alignment: .leading) {
				Text("Your Producs:").bold()
				ScrollView(.horizontal) {
					HStack(spacing: 20) {
						ForEach(self.login.meProducts) { product in
							VStack() {
								WebImage(url: URL(string: "\(product.icon)"))
									.resizable()
									.scaledToFill()
									.frame(width: 60, height: 60, alignment: .center)
									.cornerRadius(10)
								Text("\(product.name)")
							}
						}
					}
				}
			}

			Spacer()

			HStack() {
				Text(self.login.isLoggedIn ? "Logout" : "Login")
					.font(Font.system(size: 18))
					.bold()
			}
			.padding(4)
			.padding([.leading, .trailing], 10)
			.frame(minWidth: 0, maxWidth: .infinity, minHeight: 50)
			.addBorder(Color.blue, width: 2, cornerRadius: 13)
			.foregroundColor(.blue)
			.onTapGesture {
				if self.login.isLoggedIn {
					self.login.logOut()
				} else {
					self.login.login()
					self.login.getMe()
				}
			}

			Spacer().frame(height: 150)
		}.padding(10)
	}
}

//struct UserView_Previews: PreviewProvider {
//    static var previews: some View {
//        UserView()
//    }
//}
