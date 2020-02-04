//
//  AddLogData.swift
//  Makerlog
//
//  Created by Veit Progl on 04.02.20.
//  Copyright © 2020 Veit Progl. All rights reserved.
//

import Foundation
import Combine
import OAuthSwift

class AddLogData: ObservableObject {
	@Published var text: String

	init() {
		self.text = ""
	}

	func createNewLog() {

        let token = oauthswift.client.credential.oauthToken
		let parameters = ["token": token,
						  "content": "first log from #makerios 🎉",
						  "done": "true",
						  "inProgress": "false",
						  "due_at": ""]
        let requestURL = "https://api.getmakerlog.com/tasks/"

		oauthswift.startAuthorizedRequest(requestURL, method: .POST, parameters: parameters) { result in
            switch result {
            case .success(let response):
                do {
                    let decoder = JSONDecoder()
                    let data = try decoder.decode(AddLog.self, from: response.data)

					print(data)
                } catch {
					print(error)
                }
            case .failure(let error):
                print(error)
                if case .tokenExpired = error {
                  print("old token")
               }
            }
        }
	}
}
