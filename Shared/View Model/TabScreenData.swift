//
//  TabScreenData.swift
//  iOS
//
//  Created by Veit Progl on 26.02.20.
//  Copyright © 2020 Veit Progl. All rights reserved.
//

import Foundation
import Combine

class TabScreenData: ObservableObject {
	@Published var userSheet = false

	@Published var showDetailView = false
	@Published var showError = false
	@Published var errorText = "unknown error"

	@Published var showOnboarding = false
//	@Published var showSettings = false
//	@Published var showDataPolicy = false

//	@Published var showLogin = false
    
    @Published var showSheet = false
    @Published var presentSheet: TabScreenSheets = .showSettings
    @Published var webViewUrl = ""

	let defaults = UserDefaults.standard

	func getOnboarding() {
		let onboarding = defaults.bool(forKey: "Onboarding")
		self.showOnboarding = !onboarding
	}

	func setOnbaording() {
		defaults.set(true, forKey: "Onboarding")
	}

	init() {
		self.getOnboarding()
	}
}
