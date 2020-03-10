//
//  TabScreen.swift
//  Makerlog
//
//  Created by Veit Progl on 27.01.20.
//  Copyright © 2020 Veit Progl. All rights reserved.
//

import SwiftUI

struct TabBarItemData {
    var tag: Int
    var content: AnyView
}

struct TabBarPreferenceData {
    var tabBarBounds: Anchor<CGRect>? = nil
    var tabBarItemData: [TabBarItemData] = []
}

struct TabBarPreferenceKey: PreferenceKey {
    typealias Value = TabBarPreferenceData

    static var defaultValue: TabBarPreferenceData = TabBarPreferenceData()

    static func reduce(value: inout TabBarPreferenceData, nextValue: () -> TabBarPreferenceData) {
        if let tabBarBounds = nextValue().tabBarBounds {
            value.tabBarBounds = tabBarBounds
        }
        value.tabBarItemData.append(contentsOf: nextValue().tabBarItemData)
    }
}
struct CustomTabBarItem<Content: View>: View {
    let iconName: String
    let label: String
    let selection: Binding<Int>
    let tag: Int
    let content: () -> Content

    init(iconName: String,
         label: String,
         selection: Binding<Int>,
         tag: Int,
         @ViewBuilder _ content: @escaping () -> Content) {
        self.iconName = iconName
        self.label = label
        self.selection = selection
        self.tag = tag
        self.content = content
    }

    var body: some View {
        VStack(alignment: .center) {
            Image(systemName: iconName)
                .frame(minWidth: 25, minHeight: 25)
            Text(label)
				.font(.caption)
//				.multilineTextAlignment(.center)
//				.fixedSize(horizontal: false, vertical: true)
			.layoutPriority(2)
        }
        .padding([.top, .bottom], 5)
        .foregroundColor(fgColor())
        .frame(maxWidth: .infinity)
        .contentShape(Rectangle())
        .onTapGesture { self.selection.wrappedValue = self.tag }
        .preference(key: TabBarPreferenceKey.self,
                    value: TabBarPreferenceData(
                        tabBarItemData: [TabBarItemData(tag: tag,
                                                        content: AnyView(self.content())
                        )]
                    )
        )
    }

    private func fgColor() -> Color {
        return selection.wrappedValue == tag ? Color(UIColor.systemBlue) : Color(UIColor.systemGray)
    }
}

struct TabScreen: View {
	@EnvironmentObject var data: TabScreenData
	@EnvironmentObject var login: LoginData
	@EnvironmentObject var makerlog: MakerlogAPI

    @State private var showDataPolicy: Bool = false
	// swiftlint:disable empty_parentheses_with_trailing_closure
	@State private var selection: Int = 0

	var body: some View {
		VStack() {
				VStack(alignment: .center, spacing: 0) {
					HStack(alignment: .lastTextBaseline) {
						CustomTabBarItem(iconName: "house.fill",
										 label: "Home",
										 selection: $selection,
										 tag: 0) {
							NavigationView() {
								LogFeedView()
								.sheet(isPresented: self.$data.showSettings, content: {
									SettingsView(data: self.data, loginData: self.login)
								})
							}.navigationViewStyle(StackNavigationViewStyle())
						}

						CustomTabBarItem(iconName: "bubble.left.and.bubble.right.fill",
										 label:"Discussions",
										 selection: $selection,
										 tag: 1) {
							NavigationView() {
								DiscussionsView()
							}.navigationViewStyle(StackNavigationViewStyle())
						}
						CustomTabBarItem(iconName: "plus.square.fill",
										 label: "Add",
										 selection: $selection,
										 tag: 2) {
							NavigationView() {
								AddView()
							}.navigationViewStyle(StackNavigationViewStyle())
						}
						CustomTabBarItem(iconName: "bell.fill",
										 label: "Notification",
										 selection: $selection,
										 tag: 4) {
							NavigationView() {
								NotificationsView()
							}.navigationViewStyle(StackNavigationViewStyle())
						}
					}

					.background(Color(UIColor.systemGray6))
					.transformAnchorPreference(key: TabBarPreferenceKey.self,
											   value: .bounds,
											   transform: { (value: inout TabBarPreferenceData, anchor: Anchor<CGRect>) in
												value.tabBarBounds = anchor
					})
				}
				.frame(maxHeight: .infinity, alignment: .bottom)
				.overlayPreferenceValue(TabBarPreferenceKey.self) { (preferences: TabBarPreferenceData) in
					return GeometryReader { geometry in
						self.createTabBarContentOverlay(geometry, preferences)
					}
				}
			.overlay(VStack() {
				if self.data.showOnboarding {
					Onboarding()
				} else {
					EmptyView()
				}
			})
			.alert(isPresented: self.$data.showError, content: {errorAlert(errorMessage: self.data.errorText)})
			.alert(isPresented: self.$makerlog.showError, content: {errorAlert(errorMessage: self.makerlog.errorText)})
			.alert(isPresented: self.$login.showDatapolicyAlert, content: {datasecurityAlert()})
			.sheet(isPresented: self.$data.showLogin, content: {LoginScreen(login: self.login)})
		}.sheet(isPresented: self.$showDataPolicy, content: {
			NavigationView() {
				DataSecurity()
			}.navigationViewStyle(StackNavigationViewStyle())
		})
	}

	func errorAlert(errorMessage: String) -> Alert {
		let send = ActionSheet.Button.default(Text("okay")) { print("hit send") }
		return Alert(title: Text("Error!"), message: Text(errorMessage), dismissButton: send)
	}

	func datasecurityAlert() -> Alert {
		let save = ActionSheet.Button.default(Text("Accept")) {
			self.login.acceptDatapolicy()
			self.login.login()
			self.data.setOnbaording()
			self.data.showOnboarding = false
		}

        // If the cancel label is omitted, the default "Cancel" text will be shown
		let cancel = ActionSheet.Button.cancel(Text("Open policy")) { self.showDataPolicy = true }

        return Alert(title: Text("Datasecurity is important"),
                     message: Text("""
	You need to read the datasecurity policy first.
	"""),
                     primaryButton: save,
                     secondaryButton: cancel)
    }

	struct TabLabel: View {
		let imageName: String
		let label: String

		var body: some View {
			HStack {
				Image(systemName: imageName)
				Text(label)
			}
		}
	}

	private func createTabBarContentOverlay(_ geometry: GeometryProxy,
                                            _ preferences: TabBarPreferenceData) -> some View {
        let tabBarBounds = preferences.tabBarBounds != nil ? geometry[preferences.tabBarBounds!] : .zero
        let contentToDisplay = preferences.tabBarItemData.first(where: { $0.tag == self.selection })
        return ZStack {
            if contentToDisplay == nil {
                Text("Empty View")
            } else {
                contentToDisplay!.content
            }
        }
        .frame(width: geometry.size.width,
               height: geometry.size.height - tabBarBounds.size.height,
               alignment: .center)
        .position(x: geometry.size.width / 2,
                  y: (geometry.size.height - tabBarBounds.size.height) / 2) // 6
    }
}

struct TabScreen_Previews: PreviewProvider {
    static var previews: some View {
        TabScreen()
    }
}
