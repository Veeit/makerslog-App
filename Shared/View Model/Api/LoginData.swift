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

class LoginData: ApiModel, ObservableObject {

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
    @Published var meData = [User]()
	@Published var userName = "no user"
	@Published var meProducts = UserProducts()
	@Published var showDatapolicyAlert = false
	@Published var acceptedDatapolicy = false

	override init() {
		super.init()
        self.getMe()
    }

    let managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    private var responseData = [Login]()

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

				self.getMe()
            case .failure(let error):
				DispatchQueue.main.async {
					self.errorText = error.localizedDescription
					self.showError = true
				}
            }
        }
    }

	func getUserName() {
		if self.meData.first?.firstName != "" && self.meData.first?.lastName != "" {
			self.userName = "\(self.meData.first?.firstName ?? "no") \(self.meData.first?.lastName ?? "name")"
		} else {
			self.userName = self.meData.first?.username ?? "no username"
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

			self.meData = [User]()
			self.userName = "no user"

			if let bundleID = Bundle.main.bundleIdentifier {
				UserDefaults.standard.removePersistentDomain(forName: bundleID)
			}
		}
	}

    func getMe() {
        self.getLogin()

        let token = oauthswift.client.credential.oauthToken
        let parameters = ["token": token]
        let requestURL = "https://api.getmakerlog.com/me/"

        oauthswift.startAuthorizedRequest(requestURL, method: .GET, parameters: parameters) { result in
            switch result {
            case .success(let response):
                do {
                    let decoder = JSONDecoder()
                    let data = try decoder.decode(User.self, from: response.data)

                    self.meData.append(data)
					self.isLoggedIn = true
					self.getUserName()
					self.getUserProducts()
					self.setLogin()
                } catch {
                    print(error)
					self.isLoggedIn = false
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

	func getUserProducts() {
		self.getLogin()

        let token = oauthswift.client.credential.oauthToken
        let parameters = ["token": token]
		let requestURL = "https://api.getmakerlog.com/users/" + (self.meData.first?.username ?? "") + "/products/"

        oauthswift.startAuthorizedRequest(requestURL, method: .GET, parameters: parameters) { result in
            switch result {
            case .success(let response):
                do {
                    let decoder = JSONDecoder()
                    let data = try decoder.decode(UserProducts.self, from: response.data)

					self.meProducts = data
					self.setLogin()
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
