//
//  UserView.swift
//  Makerlog
//
//  Created by Veit Progl on 01.02.20.
//  Copyright © 2020 Veit Progl. All rights reserved.
//

import SwiftUI
import URLImage

struct UserView: View {
	@ObservedObject var login: LoginData
    let defaultAvartar = "https://gravatar.com/avatar/d3df4c9fe1226f2913c9579725c1e4aa?s=150&d=mm&r=pg"

	var body: some View {
		// swiftlint:disable empty_parentheses_with_trailing_closure
		List() {

			Section() {
				HStack(alignment: .center) {
					URLImage(URL(string: self.login.meData.first?.avatar ?? defaultAvartar)!,
							 processors: [
								 Resize(size: CGSize(width: 70, height: 70), scale: UIScreen.main.scale)
							 ],
							 placeholder: Image("placeholder"),
							 content: {
						$0.image
						.resizable()
						.aspectRatio(contentMode: .fit)
						.clipped()
						.cornerRadius(20)
					})
						.frame(width: 70, height: 70)
					VStack(alignment: .leading) {
						Text(self.login.userName)
								.font(.headline).bold()
						Text("@ \(self.login.meData.last?.username ?? "usernameNotFound")")

						HStack( spacing: 10) {

							Text("\(self.login.meData.first?.makerScore ?? 0) 🏆")
							Text("\(self.login.meData.first?.streak ?? 0) 🔥")
							Text("\(Int(self.login.meData.first?.weekTda ?? 0)) 🏁")
						}
						Spacer()
					}
				}

				VStack() {
					Text(self.login.meData.first?.userDescription ?? "no desciption set")
				}
			}

			Section(header: Text("Your products")) {
				ForEach(self.login.meProducts) { product in
					HStack(alignment: .top) {
						URLImage(URL(string: "\(product.icon ?? self.defaultAvartar)")!,
								processors: [ Resize(size: CGSize(width: 60, height: 60), scale: UIScreen.main.scale) ],
								content: {
									$0.image
										.resizable()
										.scaledToFill()
										.frame(width: 60, height: 60, alignment: .center)
										.cornerRadius(10)
								})
								.frame(width: 60, height: 60, alignment: .center)
						VStack(alignment: .leading) {
							HStack() {
								Text("\(product.name)").bold()
								Spacer()
								Text("\(product.launched ? "🚀" : "")").bold()
							}
							Text("\(product.productDescription ?? "no name set")")
								.multilineTextAlignment(.leading)
						}
					}
				}
			}
		}.listStyle(GroupedListStyle())
		.navigationBarTitle(self.login.userName)
	}
}
