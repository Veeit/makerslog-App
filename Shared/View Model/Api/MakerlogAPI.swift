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
import SwiftUI

class MakerlogAPI: ApiModel, ObservableObject {
	@Published var deleteItem = false

    @Published var logs = [Log]()
    @Published var isDone = false {
        didSet {
			if self.isDone {
				DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
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

	@Published var discussions: [ResultDiscussion]?
	@Published var stopTimer = false

	enum HTTPError2: LocalizedError {
		case statusCode
	}

	func startTimer() {
		self.getLogs()
		Timer.scheduledTimer(withTimeInterval: 20, repeats: true) { timer in
			self.getLogs()
			print("run")
			keychain.set(oauthswift.client.credential.oauthToken, forKey: "userToken")
			keychain.set(oauthswift.client.credential.oauthTokenSecret, forKey: "userSecret")
			keychain.set(oauthswift.client.credential.oauthRefreshToken, forKey: "userRefreshToken")
			if self.stopTimer == true {
				timer.invalidate()
			}
		}
    }

	private var alertWithNetworkError = 0

	private var cancellable: AnyCancellable?
    func getLogs() {
        print("start")
        let url = URL(string: "https://api.getmakerlog.com/tasks/?limit=200")!

		var newLogs = [Log]()
		self.cancellable = URLSession.shared.dataTaskPublisher(for: url)
			.tryMap { output in
				guard let response = output.response as? HTTPURLResponse, response.statusCode == 200 else {
					throw HTTPError2.statusCode
				}
				return output.data
			}
			.decode(type: Logs.self, decoder: JSONDecoder())
			.eraseToAnyPublisher()
			.sink(receiveCompletion: { completion in
				switch completion {
				case .finished:
					break
				case .failure(let error):
					if error.localizedDescription == "The request timed out." {
						print("time out")
					} else {
//						fatalError(error.localizedDescription)
						DispatchQueue.main.async {
							self.errorText = error.localizedDescription
							self.showError = true
							if self.alertWithNetworkError >= 1 {
								self.alertWithNetworkError += 1
							}
						}
					}
				}
			}, receiveValue: { result in
				 DispatchQueue.main.async {
					newLogs = result.results
					if newLogs != self.logs {
						self.logs = newLogs
					}
					self.isDone = true
					self.alertWithNetworkError = 0
				}
			})
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
						self.notificationisDone = true
					 }
				} catch {
					DispatchQueue.main.async {
						print(response.data)
						print(error)
						self.errorText = error.localizedDescription
						self.showError = true
					}
				}
			case .failure(let error):
				print(error)
				if case .tokenExpired = error {
				  print("old token")
			   }
				DispatchQueue.main.async {
					self.errorText = error.localizedDescription
					self.showError = true
				}
			}
		}
	}

	func addPraise(log: Log) {
		let token = oauthswift.client.credential.oauthToken
		let parameters = ["token": token, "amount": "5", "increment": "true"]
		let requestURL = "https://api.getmakerlog.com/tasks/\(log.id)/praise/"

		oauthswift.startAuthorizedRequest(requestURL, method: .POST, parameters: parameters) { result in
			switch result {
			case .success(let response):
				do {
					let generator = UINotificationFeedbackGenerator()
					generator.notificationOccurred(.success)

					let decoder = JSONDecoder()
					let data = try decoder.decode(Praise.self, from: response.data)

					DispatchQueue.main.async {
						if let index = self.logs.firstIndex(of: log) {
							self.objectWillChange.send()
							self.logs[index].praise = data.total
							print(self.logs[index].praise)
							self.getLogs()
						}
					}
				} catch {
					DispatchQueue.main.async {
						self.errorText = error.localizedDescription
						self.showError = true
					}
				}
			case .failure(let error):
				print(error)
				if case .tokenExpired = error {
				  print("old token")
			   }
				DispatchQueue.main.async {
					self.errorText = error.localizedDescription
					self.showError = true
				}
			}
		}
	}

	func getDissucions() {
		let token = oauthswift.client.credential.oauthToken
		let parameters = ["token": token, "limit": "50"]
		let requestURL = "https://api.getmakerlog.com/discussions/"

		oauthswift.startAuthorizedRequest(requestURL, method: .GET, parameters: parameters) { result in
			switch result {
			case .success(let response):
				do {
					let decoder = JSONDecoder()
					let data = try decoder.decode(Discussions.self, from: response.data)

					self.discussions = data.results
				} catch {
					DispatchQueue.main.async {
						self.errorText = error.localizedDescription
						self.showError = true
					}
				}
			case .failure(let error):
				print(error)
				if case .tokenExpired = error {
				  print("old token")
			   }
				DispatchQueue.main.async {
					self.errorText = error.localizedDescription
					self.showError = true
				}
			}
		}
	}

	func deleteLog(log: Log) {
		let token = oauthswift.client.credential.oauthToken
		let parameters = ["token": token]
		let requestURL = "https://api.getmakerlog.com/tasks/\(log.id)/"

		oauthswift.startAuthorizedRequest(requestURL, method: .DELETE, parameters: parameters) { result in
			switch result {
			case .success(_):
					self.getLogs()
			case .failure(let error):
				print(error)
				if case .tokenExpired = error {
				  print("old token")
			   }
				DispatchQueue.main.async {
					self.errorText = error.localizedDescription
					self.showError = true
				}
			}
		}
	}
}
