//
//  LoginData.swift
//  Makerlog
//
//  Created by Veit Progl on 22.01.20.
//  Copyright © 2020 Veit Progl. All rights reserved.
//

import Foundation
import Combine
import SwiftUI
import CoreData
import OAuthSwift
import KeychainSwift

class UserData: ApiModel, ObservableObject {
	@Published var userData = [User]()
	@Published var userName = "no user"
	@Published var userProducts = UserProducts()
	@Published var userRecentLogs = UserRecentLogs()
	@Published var userStats = [UserStats]()

	var stop = false
	private var cancellable: AnyCancellable?
	private var cancellableStats: AnyCancellable?
	private var cancellableProducts: AnyCancellable?

	enum HTTPError2: LocalizedError {
		case statusCode
	}
	
	private var socketConnection = WebSocketConnector(withSocketURL: URL(string: "wss:://api.getmakerlog.com/users//stream")!)
	private var logFeedConnected = false

	func setSocket() {
		socketConnection = WebSocketConnector(withSocketURL: URL(string: "wss:://api.getmakerlog.com/users/" + (String(self.userData.first?.id ?? 0)) + "/stream")!)
	}
	
	func stopSockets() {
		self.logFeedConnected = false
		self.socketConnection.disconnect()
	}

	func startSocket() {
		if !logFeedConnected {
			socketConnection.establishConnection()
		}
	}

	func getUserProducts() {
		let requestURL = "https://api.getmakerlog.com/users/" + (self.userData.first?.username ?? "") + "/products/"
		print(requestURL)

		self.cancellableProducts = URLSession.shared.dataTaskPublisher(for: URL(string: requestURL)!)
		.tryMap { output in
			guard let response = output.response as? HTTPURLResponse, response.statusCode == 200 else {
				throw HTTPError2.statusCode
			}
			return output.data
		}
		.decode(type: UserProducts.self, decoder: JSONDecoder())
		.eraseToAnyPublisher()
		.sink(receiveCompletion: { completion in
			switch completion {
			case .finished:
				break
			case .failure(let error):
				if error.localizedDescription == "The request timed out." {
					print("time out")
				} else {
					DispatchQueue.main.async {
						self.errorText = error.localizedDescription
						self.showError = true
						print(error)
					}
				}
			}
		}, receiveValue: { result in
			 DispatchQueue.main.async {
				if !self.stop {
					self.userProducts = result
					print(self.userProducts)
				}
			}
		})
	}

	func userFeedSocket() {
		socketConnection.didReceiveMessage = { message in
			do {
				let decoder = JSONDecoder()
				let data = try decoder.decode(LogsSocket.self, from: message.data(using: .utf8)!)

				DispatchQueue.main.async {
					switch data.type {
					case "task.deleted":
						print("deleted")
						self.userRecentLogs.remove(at: self.userRecentLogs.firstIndex(of: data.payload)!)
					case "task.updated":
						print("updated")
						self.userRecentLogs = self.userRecentLogs.map({ return $0.id == data.payload.id ? data.payload : $0 })
					case "task.created":
						print("created")
						self.userRecentLogs.insert(data.payload, at: 0)
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

	func getUserName() {
		if self.userData.first?.firstName != "" && self.userData.first?.lastName != "" {
			self.userName = "\(self.userData.first?.firstName ?? "no") \(self.userData.first?.lastName ?? "name")"
		} else {
			self.userName = self.userData.first?.username ?? "no username"
		}
	}

	func getUser() {
		print(oauthswift.client.credential.oauthVerifier)
        let token = oauthswift.client.credential.oauthToken
		print("user token \(token)")
		let parameters = ["token": token]
        let requestURL = "https://api.getmakerlog.com/me/"

		print("getME")

        oauthswift.startAuthorizedRequest(requestURL, method: .GET, parameters: parameters) { result in
            switch result {
            case .success(let response):
                do {
                    let decoder = JSONDecoder()
                    let data = try decoder.decode(User.self, from: response.data)

					self.userData.removeAll()
					self.userData.append(data)
					self.getUserName()
					self.getUserProducts()
					print("worked")
					print("user token \(oauthswift.client.credential.oauthToken)")
                } catch {
                    print(error)
					self.userData.removeAll()
					DispatchQueue.main.async {
						self.errorText = error.localizedDescription
						self.showError = true
					}
                }
            case .failure(let error):
                print(error)
				self.userData.removeAll()
                if case .tokenExpired = error {
                  print("old token")
               }
				print(".failure")
				DispatchQueue.main.async {
					self.errorText = error.localizedDescription
					self.showError = true
				}
            }
        }
    }

	func getRecentLogs() {
		let requestURL = "https://api.getmakerlog.com/users/" + (self.userData.first?.username ?? "") + "/recent_tasks/"

		self.cancellable = URLSession.shared.dataTaskPublisher(for: URL(string: requestURL)!)
			.tryMap { output in
				guard let response = output.response as? HTTPURLResponse, response.statusCode == 200 else {
					throw HTTPError2.statusCode
				}
				return output.data
			}
			.decode(type: UserRecentLogs.self, decoder: JSONDecoder())
			.eraseToAnyPublisher()
			.sink(receiveCompletion: { completion in
				switch completion {
				case .finished:
					break
				case .failure(let error):
					if error.localizedDescription == "The request timed out." {
						print("time out")
					} else {
						DispatchQueue.main.async {
							self.errorText = error.localizedDescription
							self.showError = true
							print(error)
						}
					}
				}
			}, receiveValue: { result in
				 DispatchQueue.main.async {
					if result != self.userRecentLogs && !self.stop {
						self.userRecentLogs = result
					}
				}
			})
	}

	func getUserStats() {
		let requestURL = "https://api.getmakerlog.com/users/" + (self.userData.first?.username ?? "") + "/stats/"

		self.cancellableStats = URLSession.shared.dataTaskPublisher(for: URL(string: requestURL)!)
		.tryMap { output in
			guard let response = output.response as? HTTPURLResponse, response.statusCode == 200 else {
				throw HTTPError2.statusCode
			}
			return output.data
		}
		.decode(type: UserStats.self, decoder: JSONDecoder())
		.eraseToAnyPublisher()
		.sink(receiveCompletion: { completion in
			switch completion {
			case .finished:
				break
			case .failure(let error):
				if error.localizedDescription == "The request timed out." {
					print("time out")
				} else {
					DispatchQueue.main.async {
						self.errorText = error.localizedDescription
						self.showError = true
						print(error)
					}
				}
			}
		}, receiveValue: { result in
			 DispatchQueue.main.async {
				self.userStats.removeAll()
				self.userStats.append(result)
			}
		})
	}
}

class UserViewData: UserData {
	init(userData: [User]) {
		super.init()
		self.userData = userData
	}
}

class LoginData: UserData {

    let generator = UINotificationFeedbackGenerator()

    @Published var isSaved = false {
        didSet {
            if self.isSaved {
                let seconds = 1.0
                self.generator.notificationOccurred(.success)
                DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                    self.isSaved = false
                    self.isOpen = false
                }
            }
        }
    }
    @Published var isOpen = false
	@Published var isLoggedIn = false
	@Published var showDatapolicyAlert = false
	@Published var acceptedDatapolicy = false

	override init() {
		super.init()
		self.isLoggedIn = defaults.bool(forKey: "isLogedIn")
        self.getUser()
		self.getDatapolicy()
    }

    let managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    private var responseData = [Login]()

	func acceptDatapolicy() {
		self.acceptedDatapolicy = true
		defaults.set(self.acceptedDatapolicy, forKey: "AcceptedDatapolicy")
	}

	func getDatapolicy() {
		self.acceptedDatapolicy = defaults.bool(forKey: "AcceptedDatapolicy")
	}

    func getLogin() {
		if oauthswift.client.credential.oauthToken == "" {
			oauthswift.client.credential.oauthToken = keychain.get("userToken") ?? ""
			oauthswift.client.credential.oauthTokenSecret = keychain.get("userSecret") ?? ""
			oauthswift.client.credential.oauthRefreshToken = keychain.get("userRefreshToken") ?? ""
		}
    }

	func setLogin() {
		keychain.set(oauthswift.client.credential.oauthToken, forKey: "userToken")
		keychain.set(oauthswift.client.credential.consumerSecret, forKey: "userSecret")
		keychain.set(oauthswift.client.credential.oauthRefreshToken, forKey: "userRefreshToken")
	}

    func login() {
        oauthswift.allowMissingStateCheck = true
        oauthswift.authorize(
            withCallbackURL: URL(string: "makerlog.ios://oauth-callback/makerlog")!,
            scope: "", state: "") { result in
            switch result {
            case .success(let (credential, response, parameters)):
              print(credential.oauthToken)
              // Do your request
                print(response ?? "w")
                print(parameters)
                print(credential)
				self.setLogin()
				self.isLoggedIn = true

				self.getUser()
            case .failure(let error):
				DispatchQueue.main.async {
					self.errorText = error.localizedDescription
					self.showError = true
				}
            }
        }
    }

	func logOut() {
		if isLoggedIn {
			keychain.clear()
			oauthswift = OAuth2Swift(
				consumerKey: "b8uO2fITOTsllzkIFsJ5S22RvsynSEn096ZnZteq",
				consumerSecret: "vop395nOpMQaKzh7BdkSBOZ8mgHClyUe1bUfDANPGLVMKoY97A3S6N9CWP2U4BPWXc5NBXHSOML2X68MDt6lChdQq3Rx4YeLqc0yQOta0DMwkLncURkGabpXQp9BjQlg",
				authorizeUrl: "https://api.getmakerlog.com/oauth/authorize/",
				accessTokenUrl: "https://api.getmakerlog.com/oauth/token/",
				responseType: "code"
			)
			self.isLoggedIn = false

			self.userData = [User]()
			self.userName = "no user"

			self.acceptedDatapolicy = false
			defaults.set(self.acceptedDatapolicy, forKey: "AcceptedDatapolicy")
			if let bundleID = Bundle.main.bundleIdentifier {
				UserDefaults.standard.removePersistentDomain(forName: bundleID)
			}
		}
	}
}
