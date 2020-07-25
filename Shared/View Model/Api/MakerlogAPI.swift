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

	@Published var discussions: [ResultDiscussion]?

	enum HTTPError2: LocalizedError {
		case statusCode
	}

	override init() {
		super.init()
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
            .receive(on: DispatchQueue.main)
			.sink(receiveCompletion: { completion in
				switch completion {
				case .finished:
					break
				case .failure(let error):
					if error.localizedDescription == "The request timed out." {
						print("time out")
					} else {
//						fatalError(error.localizedDescription)
							self.errorText = error.localizedDescription
							self.showError = true
							if self.alertWithNetworkError >= 1 {
								self.alertWithNetworkError += 1
							}
							print(error)
					}
				}
			}, receiveValue: { result in
					newLogs = result.results
					self.logs = newLogs
					self.isDone = true
					self.alertWithNetworkError = 0
                    self.cancellable?.cancel()
			})
        
//        var praisedLog = [Log]()
//        DispatchQueue.global(qos: .background).async {
//            self.logs.forEach({ log in
//                var newlog = log
//                if log.praise > 0 {
//                    newlog.praised = self.getPraise(logId: "\(log.id)")
//                }
//                praisedLog.append(newlog)
//            })
//            DispatchQueue.main.async {
//                self.logs = newLogs
//            }
//        }
	}
    
    func getPraise(logId: String) -> Bool {
        let token = oauthswift.client.credential.oauthToken
        let parameters = ["token": token]
        let requestURL = "https://api.getmakerlog.com/tasks/\(logId)/praise/"
        var praiseData = [LogsPraise]()
        
        oauthswift.startAuthorizedRequest(requestURL, method: .GET, parameters: parameters, onTokenRenewal: {
            (credential) in
            setData()
        }) { result in
            switch result {
            case .success(let response):
                do {
                    let decoder = JSONDecoder()
                    let data = try decoder.decode(LogsPraise.self, from: response.data)

                     DispatchQueue.main.async {
                        praiseData = []
                        praiseData.append(data)
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
        
        return praiseData.first?.praised ?? false
    }

	func addPraise(log: Log) {
		let token = oauthswift.client.credential.oauthToken
		let parameters = ["token": token ]
		let requestURL = "https://api.getmakerlog.com/tasks/\(log.id)/praise/"

		oauthswift.startAuthorizedRequest(requestURL, method: .POST, parameters: parameters, onTokenRenewal: {
			(credential) in
				setData()
		}) { result in
			switch result {
			case .success(let response):
				do {
					let generator = UINotificationFeedbackGenerator()
					generator.notificationOccurred(.success)

					let decoder = JSONDecoder()
					let data = try decoder.decode(PraiseNew.self, from: response.data)

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

	func deleteLog(log: Log) {
		let token = oauthswift.client.credential.oauthToken
        print(token)
//		let parameters = ["token": token]
        let parameters = ["Authorization": "Bearer \(token)"]
		let requestURL = "https://api.getmakerlog.com/tasks/\(log.id)/"

		oauthswift.startAuthorizedRequest(requestURL, method: .DELETE, parameters: parameters, onTokenRenewal: {
			(credential) in
				setData()
		}) { result in
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
