//
//  DiscussionResponse.swift
//  iOS
//
//  Created by Veit Progl on 13.02.20.
//  Copyright © 2020 Veit Progl. All rights reserved.
//

import Foundation
import OAuthSwift
import Combine

class DiscussionData: ApiModel, ObservableObject {
	@Published var discussionResponse = [DiscussionResponseElement]()
	@Published var discussion: ResultDiscussion
	@Published var reply: String = ""

	private var socketConnectionDiscussion: WebSocketConnector

	init(discussion: ResultDiscussion) {
		self.discussion = discussion
		socketConnectionDiscussion = WebSocketConnector(withSocketURL:  URL(string: "wss://api.getmakerlog.com/discussions/\(discussion.slug)/")!)

		super.init()
		self.discussionReplyUpdates()
	}

	func getDissucionsReplies() {
		let requestURL = "https://api.getmakerlog.com/discussions/\(self.discussion.slug)/replies/"

		print(requestURL)
		self.cancellablePostReply = URLSession.shared.dataTaskPublisher(for: URL(string: requestURL)!)
					.tryMap { output in
						guard let response = output.response as? HTTPURLResponse, response.statusCode == 200 else {
							throw HTTPError2.statusCode
						}
						return output.data
					}
					.decode(type: DiscussionResponse.self, decoder: JSONDecoder())
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
							self.discussionResponse = result
						}
					})
	}

	func startSocket() {
		socketConnectionDiscussion.establishConnection()
	}

	func stopSockets() {
		self.socketConnectionDiscussion.disconnect()
	}

	func discussionReplyUpdates() {
		socketConnectionDiscussion.didReceiveMessage = { message in
			print(message)
			print("something magic")

			do {
				let decoder = JSONDecoder()
				let data = try decoder.decode(DiscussionSocket.self, from: message.data(using: .utf8)!)

				DispatchQueue.main.async {
					switch data.type {
					case "reply.created":
						if data.payload.parent_reply == nil {
							self.discussionResponse.insert(data.payload, at: 0)
						}
					case "reply.updated":
						self.discussionResponse = self.discussionResponse.map({ return $0.id == data.payload.id ? data.payload : $0 })
					case "reply.deleted":
						self.discussionResponse.remove(at: self.discussionResponse.firstIndex(of: data.payload)!)
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
				self.getDissucionsReplies()
			}
        }

        socketConnectionDiscussion.didReceiveError = { error in
            //Handle error here
			DispatchQueue.main.async {
				print(error)
				self.errorText = error.localizedDescription
				self.showError = true
			}
        }

        socketConnectionDiscussion.didOpenConnection = {
            //Connection opened
			print("open Discussion")
			keychain.set(oauthswift.client.credential.oauthToken, forKey: "userToken")
			keychain.set(oauthswift.client.credential.oauthTokenSecret, forKey: "userSecret")
			keychain.set(oauthswift.client.credential.oauthRefreshToken, forKey: "userRefreshToken")
        }

        socketConnectionDiscussion.didCloseConnection = {
            // Connection closed
			print("closed Discussion")
			keychain.set(oauthswift.client.credential.oauthToken, forKey: "userToken")
			keychain.set(oauthswift.client.credential.oauthTokenSecret, forKey: "userSecret")
			keychain.set(oauthswift.client.credential.oauthRefreshToken, forKey: "userRefreshToken")
        }

        socketConnectionDiscussion.didReceiveData = { data in
            // Get your data here
			print("data")
			print(data)
        }
    }

	private var cancellablePostReply: AnyCancellable?

	enum HTTPError2: LocalizedError {
		case statusCode
	}

	func postReply() {
		let token = oauthswift.client.credential.oauthToken
		let parameters = ["token": token, "body": reply]
		let requestURL = "https://api.getmakerlog.com/discussions/\(self.discussion.slug)/replies/"

		oauthswift.startAuthorizedRequest(requestURL, method: .POST, parameters: parameters) { result in
			switch result {
			case .success(let response):
				do {
					let decoder = JSONDecoder()
					let data = try decoder.decode(DiscussionResponse.self, from: response.data)

					DispatchQueue.main.async {
						self.discussionResponse = data
					}
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
				DispatchQueue.main.async {
					self.errorText = error.localizedDescription
					self.showError = true
				}
			}
		}
	}

	func getReplyReplys(reply: DiscussionResponseElement) -> [DiscussionResponseElement] {
		var replyReplys = [DiscussionResponseElement]()
		for post in discussionResponse  where post.parent_reply == reply.id {
   				replyReplys.append(post)
		}
		return replyReplys
	}
}
