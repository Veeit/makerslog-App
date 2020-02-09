//
//  MakerlogAPI.swift
//  Makerlog
//
//  Created by Veit Progl on 21.01.20.
//  Copyright © 2020 Veit Progl. All rights reserved.
//

import Foundation
import Combine
//import OAuthSwift

class MakerlogAPI: ObservableObject {
    @Published var logs = [Result]()
    @Published var isDone = false {
        didSet {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                if self.isDone {
                    self.isDone = false
                }
            }
        }
    }
	@Published var notification: Notification?
	@Published var notificationisDone = false {
		   didSet {
			   DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
				   if self.notificationisDone {
					   self.notificationisDone = false
				   }
			   }
		   }
	   }

    func getResult() {
        print("start")
        let url = URL(string: "https://api.getmakerlog.com/tasks/?limit=200")!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            do {
               // data we are getting from network request
               let decoder = JSONDecoder()
               let response = try decoder.decode(Logs.self, from: data!)

                DispatchQueue.main.async {
                    self.logs = response.results
                    self.isDone = true
                }
            } catch {
                print(error)
            }
        }
        task.resume()
    }

	func getNotifications() {
		let token = oauthswift.client.credential.oauthToken
		let parameters = ["token": token]
		let requestURL = "https://api.getmakerlog.com/notifications/"

		oauthswift.startAuthorizedRequest(requestURL, method: .GET, parameters: parameters) { result in
			switch result {
			case .success(let response):
				do {
					let decoder = JSONDecoder()
					let data = try decoder.decode(Notification.self, from: response.data)

					 DispatchQueue.main.async {
						self.notification = data
						print(self.notification!)
						self.notificationisDone = true
					 }
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

	init() {
		getResult()
	}
}
