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


class TodayData: ApiModel, ObservableObject {
    @Published var user = [User]()
    @Published var name = "no user"
    @Published var archivments: Archivments?
    @Published var stats = [UserStats]()
    @Published var notification: Notification?

    enum NetworkError: Error {
        case url
        case server
        case timeout
    }

    func load(){
        DispatchQueue.global(qos: .utility).async {
            let result = self.getUser()
                .flatMap { _ in self.getArchivments() }
                .flatMap { _ in self.getUserStats() }
                .flatMap { _ in self.getNotifications() }
            
            DispatchQueue.main.async {
                switch result {
                case let .success(data):
                    print(data)
                case let .failure(error):
                    print("error: \(error)")
                }
            }
        }
    }
    
    func getUser() -> Result<[User], NetworkError> {
        let token = oauthswift.client.credential.oauthToken
        let parameters = ["token": token]
        let requestURL = "https://api.getmakerlog.com/me/"
        let semaphore = DispatchSemaphore(value: 0)
        var result: Result<[User], NetworkError>!

        oauthswift.startAuthorizedRequest(requestURL, method: .GET, parameters: parameters, onTokenRenewal: {
            (credential) in
            setData()
        }) { data in
            switch data {
            case .success(let response):
                do {
                    let decoder = JSONDecoder()
                    let data = try decoder.decode(User.self, from: response.data)

                     DispatchQueue.main.async {
                        self.user = [data]
                        result = .success([data])
                        semaphore.signal()
                     }
                } catch {
                    DispatchQueue.main.async {
                        print(response.data)
                        print(error)
                        result = .failure(.server)
                        semaphore.signal()
                    }
                }
            case .failure(let error):
                print(error)
                if case .tokenExpired = error {
                  print("old token")
               }
                DispatchQueue.main.async {
                    result = .failure(.server)
                    semaphore.signal()
                }
            }
        }
        
        if semaphore.wait(timeout: .now() + 15) == .timedOut {
            result = .failure(.timeout)
            semaphore.signal()
        }
        
        return result
    }
    
    func getUserName() {
        if self.user.first?.firstName != "" && self.user.first?.lastName != "" {
            self.name = "\(self.user.first?.firstName ?? "no") \(self.user.first?.lastName ?? "name")"
        } else {
            self.name = self.user.first?.username ?? "no username"
        }
    }
    
    func getArchivments() -> Result<Archivments, NetworkError> {
        let path = "https://api.getmakerlog.com/users/" + (self.user.first?.username ?? "") + "/achievements/"
        let semaphore = DispatchSemaphore(value: 0)
        var result: Result<Archivments, NetworkError>!

        guard let url = URL(string: path) else {
            return .failure(.url)
        }
        
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            if let data = data {
                let decoded = try! JSONDecoder().decode(Archivments.self, from: data)
                result = .success(decoded)
                DispatchQueue.main.async {
                    self.archivments = decoded
                }
            } else {
                result = .failure(.server)
            }
            semaphore.signal()
        }.resume()
        
        if semaphore.wait(timeout: .now() + 15) == .timedOut {
            result = .failure(.timeout)
        }
        
        return result
    }
    
    func getUserStats() -> Result<[UserStats], NetworkError> {
        let path = "https://api.getmakerlog.com/users/" + (self.user.first?.username ?? "") + "/stats/"
        let semaphore = DispatchSemaphore(value: 0)
        var result: Result<[UserStats], NetworkError>!

        guard let url = URL(string: path) else {
            return .failure(.url)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data, _, _) in
            if let data = data {
                let decoded = try! JSONDecoder().decode(UserStats.self, from: data)
                result = .success([decoded])
                DispatchQueue.main.async {
                    self.stats.removeAll()
                    self.stats.append(decoded)
                }
                
            } else {
                result = .failure(.server)
            }
            semaphore.signal()
        }.resume()
        
        if semaphore.wait(timeout: .now() + 15) == .timedOut {
            result = .failure(.timeout)
        }
        
        return result
    }
    
    func getNotifications() -> Result<Notification, NetworkError> {
        let token = oauthswift.client.credential.oauthToken
        let parameters = ["token": token]
        let requestURL = "https://api.getmakerlog.com/notifications/"
        let semaphore = DispatchSemaphore(value: 0)
        var result: Result<Notification, NetworkError>!

        oauthswift.startAuthorizedRequest(requestURL, method: .GET, parameters: parameters, onTokenRenewal: {
            (credential) in
            setData()
            result = .failure(.timeout)
            semaphore.signal()
        }) { data in
            switch data {
            case .success(let response):
                do {
                    let decoder = JSONDecoder()
                    let data = try decoder.decode(Notification.self, from: response.data)

                     DispatchQueue.main.async {
                        self.notification = data
                        result = .success(data)
                        semaphore.signal()
                     }
                } catch {
                    DispatchQueue.main.async {
                        print(response.data)
                        print(error)
                        result = .failure(.server)
                        semaphore.signal()
                    }
                }
            case .failure(let error):
                print(error)
                if case .tokenExpired = error {
                  print("old token")
               }
                DispatchQueue.main.async {
                    result = .failure(.server)
                    semaphore.signal()
                }
            }
        }
        
        if semaphore.wait(timeout: .now() + 15) == .timedOut {
            result = .failure(.timeout)
            semaphore.signal()
        }
        
        return result
    }
}

/*
 I had the problem with the code below that it is asnyc, the problem with that is that all func are called at the same time and not in the right order to get all nesseary information.
 */

class UserData: ApiModel, ObservableObject {
	@Published var userData = [User]()
	@Published var userName = "no user"
	@Published var userProducts = UserProducts()
	@Published var userRecentLogs = UserRecentLogs()
	@Published var userStats = [UserStats]()
    @Published var notification: Notification?
    @Published var archivments: Archivments?
    @Published var notificationisDone = false {
           didSet {
               DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                   if self.notificationisDone {
                       self.notificationisDone = false
                   }
               }
           }
       }
    
	var stop = false
	private var cancellable: AnyCancellable?
	private var cancellableStats: AnyCancellable?
	private var cancellableProducts: AnyCancellable?
    private var cancellableArchivments: AnyCancellable?

	enum HTTPError2: LocalizedError {
		case statusCode
	}
    
    func getNotifications() {
        let token = oauthswift.client.credential.oauthToken
        let parameters = ["token": token]
        let requestURL = "https://api.getmakerlog.com/notifications/"

        oauthswift.startAuthorizedRequest(requestURL, method: .GET, parameters: parameters, onTokenRenewal: {
            (credential) in
            setData()
        }) { result in
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
    
    func getArchivments() {
        let requestURL = "https://api.getmakerlog.com/users/" + (self.userData.first?.username ?? "") + "/achievements/"
        print(requestURL)

        self.cancellableArchivments = URLSession.shared.dataTaskPublisher(for: URL(string: requestURL)!)
        .tryMap { output in
            guard let response = output.response as? HTTPURLResponse, response.statusCode == 200 else {
                throw HTTPError2.statusCode
            }
            return output.data
        }
        .decode(type: Archivments.self, decoder: JSONDecoder())
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
                    self.archivments = result
                    print(result)
            }
        })
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

		oauthswift.startAuthorizedRequest(requestURL, method: .GET, parameters: parameters, onTokenRenewal: {
			(credential) in
				setData()
		}) { result in
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
//		let requestURL = "https://api.getmakerlog.com/users/" + (self.userData.first?.username ?? "") + "/recent_tasks/"
        let requestURL = "https://api.getmakerlog.com/tasks/?limit=50&user=\(self.userData.first?.id ?? 0)"

        print(requestURL)
		self.cancellable = URLSession.shared.dataTaskPublisher(for: URL(string: requestURL)!)
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
						DispatchQueue.main.async {
							self.errorText = error.localizedDescription
							self.showError = true
							print(error)
						}
					}
				}
			}, receiveValue: { result in
				 DispatchQueue.main.async {
                    if result.results != self.userRecentLogs && !self.stop {
                        self.userRecentLogs = result.results
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

final class LoginData: UserData {

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
//        self.getUser()
		self.getDatapolicy()
//        self.getLogin()
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
			getLoginData()
		}
    }

	func setLogin() {
		setData()
        self.isLoggedIn = true
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
            oauthswift.client.credential.oauthToken = ""
            oauthswift.client.credential.oauthTokenSecret = ""
            oauthswift.client.credential.oauthRefreshToken = ""
            oauthswift.client.credential.oauthTokenExpiresAt = Date()

			self.isLoggedIn = false

			self.userData = [User]()
			self.userName = "no user"

            do {
                try keychain.remove("userToken")
                try keychain.remove("userSecret")
                try keychain.remove("userRefreshToken")
            } catch let error {
                print("error: \(error)")
            }
            
			self.acceptedDatapolicy = false
//			defaults.set(self.acceptedDatapolicy, forKey: "AcceptedDatapolicy")
			defaults = UserDefaults.standard
			if let bundleID = Bundle.main.bundleIdentifier {
				UserDefaults.standard.removePersistentDomain(forName: bundleID)
			}
            
		}
	}
}
