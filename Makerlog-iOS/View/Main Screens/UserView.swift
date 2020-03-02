//
//  UserView.swift
//  Makerlog
//
//  Created by Veit Progl on 01.02.20.
//  Copyright © 2020 Veit Progl. All rights reserved.
//

import SwiftUI
import URLImage
import SwiftUIX
import SwiftUICharts

struct UserView: View {
	@ObservedObject var user: UserData
    let defaultAvartar = "https://gravatar.com/avatar/d3df4c9fe1226f2913c9579725c1e4aa?s=150&d=mm&r=pg"

	var body: some View {
		// swiftlint:disable empty_parentheses_with_trailing_closure opening_brace
		List() {
			Section() {
				VStack() {
					GeometryReader { geometry in
						ZStack {
							LineView(data: ChartData(points: self.user.userStats.first?.activity_trend ?? [4, 4, 4, 4, 4]), title: "")
								.padding([.top, .bottom])
								.frame(width: geometry.size.width, height: geometry.size.height)
								.offset(y: geometry.frame(in: .global).minY <= 0 ? geometry.frame(in: .global).minY/9 : -geometry.frame(in: .global).minY)
								.clipped()
								.disabled(true)
						}
					}
					.frame(height: 400)

					VStack(alignment: .center) {
						URLImage(URL(string: self.user.userData.first?.avatar ?? defaultAvartar)!,
								 processors: [
									 Resize(size: CGSize(width: 120, height: 120), scale: UIScreen.main.scale)
								 ],
								 placeholder: { _ in
									 Image("placeholer")
										 .resizable()
										 .aspectRatio(contentMode: .fit)
										 .clipped()
										 .cornerRadius(20)
										 .frame(width: 120, height: 120)
								 },
								 content: {
									$0.image
										.resizable()
										.aspectRatio(contentMode: .fit)
										.clipped()
										.cornerRadius(20)
										.frame(width: 120, height: 120)
						}).frame(width: 120, height: 120)

						if self.user.userData.first?.firstName != "" && self.user.userData.first?.lastName != "" {
							VStack(alignment: .leading) {
								Text("@\(self.user.userData.first?.username ?? "")")
									.font(.subheadline)
								Text("\(self.user.userData.first?.firstName ?? "") \(self.user.userData.first?.lastName ?? "")").font(.headline).bold()
							}
						} else {
							Text("@\(self.user.userData.first?.username ?? "")")
								.font(.headline)
						}
						Text(self.user.userData.first?.userDescription ?? "no discription")
							.font(.subheadline)
					}.frame(minWidth: 0, maxWidth: .infinity)
					.padding([.top], -230)
				}

				VStack() {
					Group() {
						ScrollView(.horizontal, showsIndicators: false) {
							HStack() {
								HStack() {
									Spacer()
									VStack() {
										Text("Rest days").font(.subheadline)
										Text("\(self.user.userStats.first?.rest_day_balance ?? 0)").bold()
									}
									Spacer()
									Divider()
								}.frame(width: 100)
								HStack() {
									Spacer()
									VStack() {
										Text("Follower").font(.subheadline)
										Text("\(self.user.userStats.first?.follower_count ?? 0)").bold()
									}
									Spacer()
									Divider()
								}.frame(width: 100)
								HStack() {
									Spacer()
									VStack() {
										Text("Maker score").font(.subheadline)
										Text("\(self.user.userStats.first?.maker_score ?? 0)").bold()
									}
									Spacer()
									Divider()
								}.frame(width: 100)
								HStack() {
									Spacer()
									VStack() {
										Text("Streak").font(.subheadline)
										Text("\(self.user.userStats.first?.streak ?? 0)").bold()
									}
									Spacer()
									Divider()
								}.frame(width: 100)
								HStack() {
									Spacer()
									VStack() {
										Text("Done today").font(.subheadline)
										Text("\(self.user.userStats.first?.done_today ?? 0)").bold()
									}
									Spacer()
									Divider()
								}.frame(width: 100)
								HStack() {
									Spacer()
									VStack() {
										Text("Remaining today").font(.subheadline)
										Text("\(self.user.userStats.first?.remaining_tasks ?? 0)").bold()
									}
									Spacer()
									Divider()
								}.frame(width: 100)
								HStack() {
									Spacer()
									VStack() {
										Text("Done total").font(.subheadline)
										Text("\(self.user.userStats.first?.done_today ?? 0)").bold()
									}
									Spacer()
								}.frame(width: 100)
							}
						}
					}
				}

				Section(header: Text("Products").bold()) {
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
									.lineLimit(nil)
									.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .leading)
									.fixedSize(horizontal: false, vertical: true)
							}
						}
					}
				}

				Spacer()
				Section(header: Text("Last logs").bold()) {
					ForEach(self.user.userRecentLogs) { log in
						NavigationLink(destination: LogDetailView(log: LogViewData(data: log))) {
							VStack() {
								HStack(alignment: .top) {
									Spacer()
									ProgressImg(done: log.done, inProgress: log.inProgress)
									EventImg(event: log.event ?? "")
									Text("👏 \(log.praise)").bold()
								}
								Text("\(log.content)")
									.multilineTextAlignment(.leading)
									.lineLimit(nil)
									.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .leading)
									.fixedSize(horizontal: false, vertical: true)
							}
						}
					}
				}
            }
        }
		.listStyle(DefaultListStyle())
		.navigationBarTitle("\(self.user.userName)", displayMode: .inline)
		.onAppear(perform: {
			self.user.getUserProducts()
			self.user.getUserName()
			self.user.getRecentLogs()
			self.user.getUserStats()
		})
	}
}
