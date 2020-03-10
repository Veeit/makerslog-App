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

	enum HTTPError2: LocalizedError {
		case statusCode
	}

	override init() {
		super.init()
		self.startSocket()
		socketConnection.setlistener()
		self.feedSocket()
		self.getDissucions()
		if defaults.bool(forKey: "isLogedIn") {
			self.getNotifications()
		}
	}

	private let socketConnection = WebSocketConnector(withSocketURL: URL(string: "wss://api.getmakerlog.com/explore/stream/")!)
	private var logFeedConnected = false

	func stopSockets() {
		self.logFeedConnected = false
		self.socketConnection.disconnect()
		cancellable?.cancel()
	}

	func startSocket() {
		self.getLogs()
		if !logFeedConnected {
			socketConnection.establishConnection()
			self.logFeedConnected = true
		}
	}

	func feedSocket() {
		socketConnection.didReceiveMessage = { message in

			do {
				let decoder = JSONDecoder()
				let data = try decoder.decode(LogsSocket.self, from: message.data(using: .utf8)!)

				DispatchQueue.main.async {
					switch data.type {
					case "task.sync":
						print("sync")
					case "task.deleted":
						print("deleted")
						self.logs.remove(at: self.logs.firstIndex(of: data.payload)!)
					case "task.updated":
						print("updated")
						self.logs = self.logs.map({ return $0.id == data.payload.id ? data.payload : $0 })
					case "task.created":
						print("created")
						self.logs.insert(data.payload, at: 0)
					default:
						print("upps")
					}
				}
			} catch {
				DispatchQueue.main.async {
					print(error)
					self.errorText = error.localizedDescription
					self.showError = true
				}
				self.getLogs()
			}
			print("something magic")
        }

        socketConnection.didReceiveError = { error in
            //Handle error here
			DispatchQueue.main.async {
				print(error)
				self.errorText = error.localizedDescription
				self.showError = true
			}
        }

        socketConnection.didOpenConnection = {
            //Connection opened
			print("open")
			keychain.set(oauthswift.client.credential.oauthToken, forKey: "userToken")
			keychain.set(oauthswift.client.credential.oauthTokenSecret, forKey: "userSecret")
			keychain.set(oauthswift.client.credential.oauthRefreshToken, forKey: "userRefreshToken")
			self.logFeedConnected = true
        }

        socketConnection.didCloseConnection = {
            // Connection closed
			print("closed")
			keychain.set(oauthswift.client.credential.oauthToken, forKey: "userToken")
			keychain.set(oauthswift.client.credential.oauthTokenSecret, forKey: "userSecret")
			keychain.set(oauthswift.client.credential.oauthRefreshToken, forKey: "userRefreshToken")
			self.logFeedConnected = false
        }

        socketConnection.didReceiveData = { data in
            // Get your data here
			print("data")
			print(data)
        }
    }

	private var alertWithNetworkError = 0

	private var cancellable: AnyCancellable?
	private var cancellableDiscussion: AnyCancellable?

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
							print(error)
						}
					}
				}
			}, receiveValue: { result in
				 DispatchQueue.main.async {
					newLogs = result.results
					self.logs = newLogs
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
		let requestURL = "https://api.getmakerlog.com/discussions/?limit=50"
		let request = URLRequest(url: URL(string: requestURL)!)

		print("start Discussion")

		self.cancellableDiscussion = URLSession.shared.dataTaskPublisher(for: request)
			.tryMap { output in
				guard let response = output.response as? HTTPURLResponse, response.statusCode == 200 else {
					throw HTTPError2.statusCode
				}
				return output.data
			}
			.decode(type: Discussions.self, decoder: JSONDecoder())
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
					 self.discussions = result.results
				 }
			})
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
