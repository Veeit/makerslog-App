//
//  UserView.swift
//  Makerlog
//
//  Created by Veit Progl on 01.02.20.
//  Copyright © 2020 Veit Progl. All rights reserved.
//

import SwiftUI
//import URLImage
import SDWebImageSwiftUI
import SwiftUIX
import SwiftUICharts

struct UserView: View {
	@EnvironmentObject var user: UserData
    @EnvironmentObject var tabScreenData: TabScreenData

	var userData: [User]
    var fromLog = false
    let defaultAvartar = "https://gravatar.com/avatar/d3df4c9fe1226f2913c9579725c1e4aa?s=150&d=mm&r=pg"

    @State var showContact = false

	var body: some View {
		// swiftlint:disable empty_parentheses_with_trailing_closure opening_brace
		VStack() {
			List() {
				Section() {
					VStack() {
						HStack(alignment: .center) {
							WebImage(url: URL(string: self.user.userData.first?.avatar ?? self.defaultAvartar),
								 options: [.decodeFirstFrameOnly],
								 context: [.imageThumbnailPixelSize: CGSize(width: 240, height: 240)])
							.placeholder(Image("imagePlaceholder"))
							.resizable()
							.aspectRatio(contentMode: .fit)
							.frame(width: 120, height: 120)
							.clipped()
							.cornerRadius(20)

                            VStack() {
                                if self.user.userData.first?.firstName != "" && self.user.userData.first?.lastName != "" {
                                    VStack(alignment: .leading) {
                                        Text("@\(self.user.userData.first?.username ?? "")")
                                            .font(.subheadline)
                                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                        Text("\(self.user.userData.first?.firstName ?? "") \(self.user.userData.first?.lastName ?? "")")
                                            .font(.headline).bold()
                                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                    }
                                } else {
                                    Text("@\(self.user.userData.first?.username ?? "")")
                                        .font(.headline)
                                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                }
                                Text(self.user.userData.first?.userDescription ?? "no discription")
                                    .font(.subheadline)
                                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                Divider()
  
                                Text("Contact")
                                    .foregroundColor(Color.blue)
                                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                    .onTapGesture {
                                        self.showContact.toggle()
                                    }
                                Text("Statistics")
                                   .foregroundColor(Color.blue)
                                   .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                   .onTapGesture {
                                       self.showContact.toggle()
                                   }
                            }
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .padding([.top], 20)
						}.frame(minWidth: 0, maxWidth: .infinity)
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
								WebImage(url: URL(string: "\(product.icon ?? self.defaultAvartar)")!,
									 options: [.decodeFirstFrameOnly],
									 context: [.imageThumbnailPixelSize: CGSize(width: 120, height: 120)])
								.placeholder(Image("imagePlaceholder"))
								.resizable()
								.aspectRatio(contentMode: .fit)
								.frame(width: 60, height: 60)
								.clipped()
								.cornerRadius(20)
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
							}.frame(minHeight: 60)
						}
					}

					Spacer()
					Section(header: Text("Last logs").bold()) {
                        ForEach(self.user.userRecentLogs) { log in
							NavigationLink(destination: LogDetailView(log: LogViewData(data: log), fromUser: true)) {
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
		}
//		.navigationBarTitle("\(self.user.userName)", displayMode: .inline)
		.onAppear(perform: {
			self.user.stop = false
			self.user.userData = self.userData
			self.user.getUserProducts()
			self.user.getUserName()
			self.user.getRecentLogs()
			self.user.getUserStats()
		})
        
        .sheet(isPresented: self.$showContact, content: {
            ContactScreen(user: self.user.userData[0])
        })
	}
}
