//
//  LoginScreen.swift
//  iOS
//
//  Created by Veit Progl on 25.02.20.
//  Copyright © 2020 Veit Progl. All rights reserved.
//

import SwiftUI

struct LoginScreen: View {
	var login: LoginData
    var body: some View {
//		swiftlint:disable empty_parentheses_with_trailing_closure multiple_closures_with_trailing_closure
		VStack() {
			Text("You must be logged in for this function!")
			Button(action: {
				self.login.login()
				self.login.getUser()
			}) {
				Text("Login")
			}.frame(minWidth: 0, maxWidth: .infinity, minHeight: 40)
			 .background(Color.blue)
			.foregroundColor(Color.white)
			.cornerRadius(10)
				.padding([.top], 20)
		}.padding(30)
    }
}
