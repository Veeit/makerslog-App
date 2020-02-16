//
//  CommentViewData.swift
//  Makerlog
//
//  Created by Veit Progl on 21.01.20.
//  Copyright © 2020 Veit Progl. All rights reserved.
//

import Foundation
import Combine
import OAuthSwift

class CommentViewData: ObservableObject {
    @Published var comments = Comment()

	enum HTTPError2: LocalizedError {
		case statusCode
	}
	
//	init(logID: Int) {
//		self.getComments(logID: "\(logID)")
//	}

	private var cancellable: AnyCancellable?
    func getComments(logID: String) -> Comment {
        let url = URL(string: "https://api.getmakerlog.com/tasks/\(logID)/comments/")!
		print(url)

//		let token = oauthswift.client.credential.oauthToken
//		let parameters = ["token": token]
//
//		oauthswift.startAuthorizedRequest(url, method: .GET, parameters: parameters) { result in
//			switch result {
//			case .success(let response):
//				do {
//					let decoder = JSONDecoder()
//					let data = try decoder.decode(Comment.self, from: response.data)
//
//					DispatchQueue.main.async {
//						self.comments = data
//						print(self.comments)
//					}
//				} catch {
//					print(error.localizedDescription)
//				}
//			case .failure(let error):
//				print(error.localizedDescription)
//				if case .tokenExpired = error {
//				  print("old token")
//			   }
//			}
//		}

		self.cancellable = URLSession.shared.dataTaskPublisher(for: url)
			.tryMap { output in
				guard let response = output.response as? HTTPURLResponse, response.statusCode == 200 else {
					throw HTTPError2.statusCode
				}
				return output.data
			}
			.decode(type: Comment.self, decoder: JSONDecoder())
			.eraseToAnyPublisher()
			.sink(receiveCompletion: { completion in
				switch completion {
				case .finished:
					print("done with that")
					break
				case .failure(let error):
					if error.localizedDescription == "The request timed out." {
						print("time out")
					} else {
						fatalError(error.localizedDescription)
					}
				}
			}, receiveValue: { result in
				 DispatchQueue.main.async {
					self.comments = result
					print(self.comments)
					self.cancellable?.cancel()
				}
			})
		return self.comments
	}

	func addComment(logID: Int, content: String) {

		let token = oauthswift.client.credential.oauthToken
		let parameters = ["token": token, "content": content]
		let requestURL = "https://api.getmakerlog.com/tasks/\(String(logID))/comments/"

		oauthswift.startAuthorizedRequest(requestURL, method: .POST, parameters: parameters) { result in
			switch result {
			case .success(let response):
				do {
					let decoder = JSONDecoder()
					let data = try decoder.decode(CommentElement.self, from: response.data)

					self.comments.append(data)
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
}
