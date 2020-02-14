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

class DiscussionModel: ObservableObject {
	@Published var discussionResponse: DiscussionResponse?
	@Published var discussion: ResultDiscussion
	@Published var reply: String = ""

	init(discussion: ResultDiscussion) {
		self.discussion = discussion
	}

	func getDissucionsReplies() {
		let token = oauthswift.client.credential.oauthToken
		let parameters = ["token": token]
		let requestURL = "https://api.getmakerlog.com/discussions/\(self.discussion.slug)/replies/"

		oauthswift.startAuthorizedRequest(requestURL, method: .GET, parameters: parameters) { result in
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
				}
			case .failure(let error):
				print(error)
				if case .tokenExpired = error {
				  print("old token")
			   }
			}
		}
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
				}
			case .failure(let error):
				print(error)
				if case .tokenExpired = error {
				  print("old token")
			   }
			}
		}
	}
	
	func getReplyReplys(reply: DiscussionResponseElement) -> [DiscussionResponseElement] {
		var replyReplys = [DiscussionResponseElement]()
		for post in discussionResponse! {
			if post.parent_reply == reply.id {
   				replyReplys.append(post)
			}
		}
		return replyReplys
	}
}
