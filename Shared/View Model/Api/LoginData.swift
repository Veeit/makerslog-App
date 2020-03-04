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
	func getUserProducts() {
        let token = oauthswift.client.credential.oauthToken
        let parameters = ["token": token]
		let requestURL = "https://api.getmakerlog.com/users/" + (self.userData.first?.username ?? "") + "/products/"
		print(requestURL)

        oauthswift.startAuthorizedRequest(requestURL, method: .GET, parameters: parameters) { result in
            switch result {
            case .success(let response):
                do {
                    let decoder = JSONDecoder()
                    let data = try decoder.decode(UserProducts.self, from: response.data)

					if !self.stop {
						self.userProducts = data
					}
				} catch {
                    print(error)
					print("decode error")
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

        oauthswift.startAuthorizedRequest(requestURL, method: .GET, parameters: parameters) { result in
            switch result {
            case .success(let response):
                do {
                    let decoder = JSONDecoder()
                    let data = try decoder.decode(User.self, from: response.data)

                    self.userData.append(data)
					self.getUserName()
					self.getUserProducts()
					print("worked")
					print("user token \(oauthswift.client.credential.oauthToken)")
                } catch {
                    print(error)
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
				print(".failure")
				DispatchQueue.main.async {
					self.errorText = error.localizedDescription
					self.showError = true
				}
            }
        }
    }

	func getRecentLogs() {
		let token = oauthswift.client.credential.oauthToken
        let parameters = ["token": token]
		let requestURL = "https://api.getmakerlog.com/users/" + (self.userData.first?.username ?? "") + "/recent_tasks/"

		var newLogs = UserRecentLogs()
        oauthswift.startAuthorizedRequest(requestURL, method: .GET, parameters: parameters) { result in
            switch result {
            case .success(let response):
                do {
                    let decoder = JSONDecoder()
                    let data = try decoder.decode(UserRecentLogs.self, from: response.data)

					newLogs = data
					if newLogs != self.userRecentLogs && !self.stop {
						self.userRecentLogs = newLogs
					}
                } catch {
                    print(error)
					print("decode error")
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

	func getUserStats() {
		let token = oauthswift.client.credential.oauthToken
        let parameters = ["token": token]
		let requestURL = "https://api.getmakerlog.com/users/" + (self.userData.first?.username ?? "") + "/stats/"

        oauthswift.startAuthorizedRequest(requestURL, method: .GET, parameters: parameters) { result in
            switch result {
            case .success(let response):
                do {
                    let decoder = JSONDecoder()
                    let data = try decoder.decode(UserStats.self, from: response.data)
					if !self.stop {
						DispatchQueue.main.async {
							self.userStats.append(data)
						}
					}
                } catch {
                    print(error)
					print("decode error")
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
			if let bundleID = Bundle.main.bundleIdentifier {
				UserDefaults.standard.removePersistentDomain(forName: bundleID)
			}
		}
	}
}
