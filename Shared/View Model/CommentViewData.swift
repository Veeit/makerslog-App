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

	private var cancellable: AnyCancellable?
    func getComments(logID: String) {
        let url = URL(string: "https://api.getmakerlog.com/tasks/\(logID)/comments/")!

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
					break
				case .failure(let error):
					fatalError(error.localizedDescription)
				}
			}, receiveValue: { response in
				 DispatchQueue.main.async {
					self.comments = response
				}
			})
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
