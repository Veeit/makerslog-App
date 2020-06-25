////
////  DiscussionResponse.swift
////  iOS
////
////  Created by Veit Progl on 13.02.20.
////  Copyright © 2020 Veit Progl. All rights reserved.
////
//
//import Foundation
//import OAuthSwift
//import Combine
//
//class DiscussionData: ApiModel, ObservableObject {
//	@Published var discussionResponse = [DiscussionResponseElement]()
//	@Published var discussion: ResultDiscussion
//	@Published var reply: String = ""
//
//	init(discussion: ResultDiscussion) {
//		self.discussion = discussion
//	}
//
//	func getDissucionsReplies() {
//		let requestURL = "https://api.getmakerlog.com/discussions/\(self.discussion.slug)/replies/"
//
//		print(requestURL)
//		self.cancellablePostReply = URLSession.shared.dataTaskPublisher(for: URL(string: requestURL)!)
//					.tryMap { output in
//						guard let response = output.response as? HTTPURLResponse, response.statusCode == 200 else {
//							throw HTTPError2.statusCode
//						}
//						return output.data
//					}
//					.decode(type: DiscussionResponse.self, decoder: JSONDecoder())
//					.eraseToAnyPublisher()
//					.sink(receiveCompletion: { completion in
//						switch completion {
//						case .finished:
//							break
//						case .failure(let error):
//							if error.localizedDescription == "The request timed out." {
//								print("time out")
//							} else {
//								DispatchQueue.main.async {
//									self.errorText = error.localizedDescription
//									self.showError = true
//									print(error)
//								}
//							}
//						}
//					}, receiveValue: { result in
//						 DispatchQueue.main.async {
//                            if self.discussionResponse.count <= result.count {
//                                self.discussionResponse = result
//                            }
//						}
//					})
//	}
//
//	private var cancellablePostReply: AnyCancellable?
//
//	enum HTTPError2: LocalizedError {
//		case statusCode
//	}
//
//    func postReply() {
//		let token = oauthswift.client.credential.oauthToken
//		let parameters = ["token": token, "body": reply]
//		let requestURL = "https://api.getmakerlog.com/discussions/\(self.discussion.slug)/replies/"
//
//		oauthswift.startAuthorizedRequest(requestURL, method: .POST, parameters: parameters, onTokenRenewal: {
//			(credential) in
//				setData()
//		}) { result in
//			switch result {
//			case .success(let response):
//				do {
//					let decoder = JSONDecoder()
//					let data = try decoder.decode(DiscussionResponse.self, from: response.data)
//
//					DispatchQueue.main.async {
//						self.discussionResponse = data
//					}
//				} catch {
//					print(error)
//					DispatchQueue.main.async {
//						self.errorText = error.localizedDescription
//						self.showError = true
//					}
//				}
//			case .failure(let error):
//				print(error)
//				if case .tokenExpired = error {
//				  print("old token")
//			   }
//				DispatchQueue.main.async {
//					self.errorText = error.localizedDescription
//					self.showError = true
//				}
//			}
//		}
//	}
//
//	func getReplyReplys(reply: DiscussionResponseElement) -> [DiscussionResponseElement] {
//        var replyReplys = [DiscussionResponseElement]()
//		for post in discussionResponse  where post.parent_reply == reply.id {
//   				replyReplys.append(post)
//		}
//		return replyReplys
//	}
//}
