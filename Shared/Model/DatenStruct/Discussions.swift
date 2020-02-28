// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let discussions = try? newJSONDecoder().decode(Discussions.self, from: jsonData)

import Foundation

// MARK: - Discussions
// swiftlint:disable all
struct Discussions: Codable {
    let count: Int
    let next: String?
//    let previous: String?
    let results: [ResultDiscussion]
}

// MARK: - Result
struct ResultDiscussion: Codable, Identifiable {
    let id: Int
    let slug: String
    let type: String
    let owner: User
    let title, body: String
    let pinned: Bool
    let createdAt, updatedAt: String?
    let reply_count: Int?

    enum CodingKeys: String, CodingKey {
        case id, slug, type, owner, title, body, pinned
        case createdAt
        case updatedAt
        case reply_count
    }
}
