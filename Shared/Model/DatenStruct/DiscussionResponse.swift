// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let discussionResponse = try? newJSONDecoder().decode(DiscussionResponse.self, from: jsonData)

import Foundation

// swiftlint:disable all
// MARK: - DiscussionResponseElement
struct DiscussionResponseElement: Codable, Identifiable {
    let id: Int
    let parent: String
    let parent_reply: Int?
    let owner: User
    let body: String
    let praise: Int
    let created_at, updated_at: String?

    enum CodingKeys: String, CodingKey {
        case id, parent
        case parent_reply
        case owner, body, praise
        case created_at
        case updated_at
    }
}

typealias DiscussionResponse = [DiscussionResponseElement]
