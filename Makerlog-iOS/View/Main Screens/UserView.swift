//
//  UserView.swift
//  Makerlog
//
//  Created by Veit Progl on 01.02.20.
//  Copyright © 2020 Veit Progl. All rights reserved.
//

import SwiftUI
import URLImage
import SwiftUICharts

struct UserView: View {
	@ObservedObject var user: UserData
    let defaultAvartar = "https://gravatar.com/avatar/d3df4c9fe1226f2913c9579725c1e4aa?s=150&d=mm&r=pg"

	var body: some View {
		// swiftlint:disable empty_parentheses_with_trailing_closure
		List() {
			Section() {
				HStack(alignment: .center) {
					URLImage(URL(string: self.user.userData.first?.avatar ?? defaultAvartar)!,
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
						Text(self.user.userName)
								.font(.headline).bold()
						Text("@ \(self.user.userData.last?.username ?? "usernameNotFound")")

						HStack( spacing: 10) {
							Text("\(self.user.userData.first?.makerScore ?? 0) 🏆")
							Text("\(self.user.userData.first?.streak ?? 0) 🔥")
							Text("\(Int(self.user.userData.first?.weekTda ?? 0)) 🏁")
						}
						Spacer()
					}
				}

				VStack() {
					Text(self.user.userData.first?.userDescription ?? "no desciption set")
				}
			}

			Section(header: Text("Your products")) {
				ForEach(self.user.userProducts) { product in
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

			Section() {
				BarChartView(data: ChartData(points: self.user.userStats?.done_week.datasets[0].data ?? [0, 0, 0, 5]), title: "Title")
			}
			Section(header: Text("Your Logs")) {
				ForEach(self.user.userRecentLogs) { log in
					NavigationLink(destination: LogDetailView(log: LogViewData(data: log))) {
						HStack(alignment: .top) {
							VStack(alignment: .leading) {
								HStack() {
									Spacer()
									ProgressImg(done: log.done, inProgress: log.inProgress)
									EventImg(event: log.event ?? "")
									Text("👏 \(log.praise)").bold()
								}
								Text("\(log.content)")
									.multilineTextAlignment(.leading)
							}
						}
					}
				}
			}
		}
		.listStyle(GroupedListStyle())
		.navigationBarTitle(self.user.userName)
		.onAppear(perform: {
			self.user.getUserProducts()
			self.user.getUserName()
			self.user.getRecentLogs()
			self.user.getUserStats()
		})
	}
}
