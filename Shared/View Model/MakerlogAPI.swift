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

public func delay(bySeconds seconds: Double, dispatchLevel: DispatchLevel = .main, closure: @escaping () -> Void) {
    let dispatchTime = DispatchTime.now() + seconds
    dispatchLevel.dispatchQueue.asyncAfter(deadline: dispatchTime, execute: closure)
}

public enum DispatchLevel {
    case main, userInteractive, userInitiated, utility, background
    var dispatchQueue: DispatchQueue {
        switch self {
        case .main:                 return DispatchQueue.main
        case .userInteractive:      return DispatchQueue.global(qos: .userInteractive)
        case .userInitiated:        return DispatchQueue.global(qos: .userInitiated)
        case .utility:              return DispatchQueue.global(qos: .utility)
        case .background:           return DispatchQueue.global(qos: .background)
        }
    }
}

class MakerlogAPI: ObservableObject {
    @Published var logs = [Result]()
    @Published var isDone = false {
        didSet {
			if self.isDone {
				DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
					self.cancellable?.cancel()
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

	enum HTTPError2: LocalizedError {
		case statusCode
	}

    private func startTimer() {
		self.getResult()

		Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { _ in
			self.getResult()
			print("run")
		}
    }

	private var cancellable: AnyCancellable?
    func getResult() {
        print("start")
        let url = URL(string: "https://api.getmakerlog.com/tasks/?limit=200")!

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
					fatalError(error.localizedDescription)
				}
			}, receiveValue: { result in
				 DispatchQueue.main.async {
					self.logs = result.results
					self.isDone = true
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

	func addPraise(log: Result) {
		let token = oauthswift.client.credential.oauthToken
		let parameters = ["token": token, "amount": "5"]
		let requestURL = "https://api.getmakerlog.com/tasks/\(log.id)/praise/"

		oauthswift.startAuthorizedRequest(requestURL, method: .POST, parameters: parameters) { result in
			switch result {
			case .success(let response):
				do {
					let decoder = JSONDecoder()
					let data = try decoder.decode(Praise.self, from: response.data)

					DispatchQueue.main.async {
						if let index = self.logs.firstIndex(of: log) {
							self.objectWillChange.send()
							self.logs[index].praise = data.total
							print(self.logs[index].praise)
							self.getResult()
						}
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
		startTimer()
	}
}
