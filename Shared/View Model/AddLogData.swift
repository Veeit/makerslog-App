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
	@Published var text = ""
	@Published var isDone = false
	@Published var isProgress = false

	func createNewLog() {

        let token = oauthswift.client.credential.oauthToken
		let parameters = ["token": token,
						  "content": text,
						  "done": "\(isDone)",
						  "inProgress": "\(isProgress)",
						  "due_at": ""]
        let requestURL = "https://api.getmakerlog.com/tasks/"

		oauthswift.startAuthorizedRequest(requestURL, method: .POST, parameters: parameters) { result in
            switch result {
            case .success(let response):
                do {
                    let decoder = JSONDecoder()
                    let data = try decoder.decode(AddLog.self, from: response.data)

					self.isDone = false
					self.isProgress = false
					self.text = ""
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
