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
    @Published var userToken = ""
    @Published var userSecret = ""
	@Published var userRefreshToken = ""
    @Published var meData = [User]()
	@Published var userName = "no user"
	@Published var meProducts = UserProducts()

	override init() {
		super.init()
        self.getMe()
    }

    let managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    let keychain = KeychainSwift()
    private var responseData = [Login]()

    func checkLogin() {
        self.userToken = keychain.get("userToken") ?? ""
        self.userSecret = keychain.get("userSecret") ?? ""

        oauthswift.client.credential.oauthToken = self.userToken
        oauthswift.client.credential.oauthTokenSecret = self.userSecret
        print("user Token: \(self.userToken)")
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
                self.userToken = credential.oauthToken
                self.userSecret = credential.consumerSecret
				self.userRefreshToken = credential.oauthRefreshToken
				print(self.userRefreshToken)
//				print(JSON.stringify({refresh_token: refreshToken}))
                self.keychain.set(self.userToken, forKey: "userToken")
                self.keychain.set(self.userSecret, forKey: "userSecret")
				self.isLoggedIn = true

				self.getMe()
            case .failure(let error):
//				print(error.localizedDescription)
//				print(result)
				
				if self.userRefreshToken != "" {
//					self.refreshToken()
					print(error.localizedDescription)
					DispatchQueue.main.async {
						self.errorText = error.localizedDescription
						self.showError = true
					}
				} else {
					DispatchQueue.main.async {
						self.errorText = error.localizedDescription
						self.showError = true
					}
				}
            }
        }
    }
	
	private var cancellable: AnyCancellable?

	enum HTTPError2: LocalizedError {
		case statusCode
	}
	
//	func refreshToken() {
//		/*
//		function refreshMakerlogToken(notify = false) {
//			if(typeof refreshToken !== 'undefined' && refreshToken.length > 0) {
//				return fetch('https://makerlog-menubar-cloud-functions.netlify.com/.netlify/functions/refreshMakerlogToken', {
//					method: 'POST',
//					body: JSON.stringify({refresh_token: refreshToken})
//				}).then(r => r.json()).then(r => {
//					token = r.access_token;
//					refreshToken = r.refresh_token;
//					getGlobal('storeToken')(`${token}|${refreshToken}`);
//					if(notify) {
//						alert('Failed. Please try that again!')
//					}
//					if(data.taskComposer.content.length == 0) {
//						window.location.reload();
//					}
//				}, err => alert('Failed. Please try that again!'))
//				.catch(r => alert('Failed. Please try that again!'))
//			} else {
//				login(); // Can't refresh so log in again
//			}
//		}
//		*/
//
//		let url = URL(string: "https://makerlog-menubar-cloud-functions.netlify.com/.netlify/functions/refreshMakerlogToken")!
//
//				self.cancellable = URLSession.shared.dataTaskPublisher(for: url)
//					.tryMap { output in
//						guard let response = output.response as? HTTPURLResponse, response.statusCode == 200 else {
//							throw HTTPError2.statusCode
//						}
//						return output.data
//					}
//					.decode(type: Logs.self, decoder: JSONDecoder())
//					.eraseToAnyPublisher()
//					.sink(receiveCompletion: { completion in
//						switch completion {
//						case .finished:
//							break
//						case .failure(let error):
//							if error.localizedDescription == "The request timed out." {
//								print("time out")
//							} else {
//		//						fatalError(error.localizedDescription)
//								DispatchQueue.main.async {
//
//
//								}
//							}
//						}
//					}, receiveValue: { result in
//						 DispatchQueue.main.async {
//
//						}
//					})
//
//		print(self.userRefreshToken)
//	}

	func getUserName() {
		self.checkLogin()
		if self.meData.first?.firstName != "" && self.meData.first?.lastName != "" {
			self.userName = "\(self.meData.first?.firstName ?? "no") \(self.meData.first?.lastName ?? "name")"
		} else {
			self.userName = self.meData.first?.username ?? "no username"
		}
	}

	func logOut() {
		if isLoggedIn {
			self.keychain.clear()
			oauthswift = OAuth2Swift(
				consumerKey: "b8uO2fITOTsllzkIFsJ5S22RvsynSEn096ZnZteq",
				consumerSecret: "vop395nOpMQaKzh7BdkSBOZ8mgHClyUe1bUfDANPGLVMKoY97A3S6N9CWP2U4BPWXc5NBXHSOML2X68MDt6lChdQq3Rx4YeLqc0yQOta0DMwkLncURkGabpXQp9BjQlg",
				authorizeUrl: "https://api.getmakerlog.com/oauth/authorize/",
				accessTokenUrl: "https://api.getmakerlog.com/oauth/token/",
				responseType: "code"
			)
			self.isLoggedIn = false

			self.meData = [User]()
			self.userToken = ""
			self.userSecret = ""
			self.userName = "no user"
			self.userRefreshToken = ""

			if let bundleID = Bundle.main.bundleIdentifier {
				UserDefaults.standard.removePersistentDomain(forName: bundleID)
			}
		}
	}

    func getMe() {
        self.checkLogin()

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
		self.checkLogin()

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
