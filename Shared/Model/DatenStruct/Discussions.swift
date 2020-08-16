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
    let previous: String?
    let results: [ResultDiscussion]
}

// MARK: - Result
struct ResultDiscussion: Codable, Identifiable, Equatable {
    static func == (lhs: ResultDiscussion, rhs: ResultDiscussion) -> Bool {
        return lhs.id == rhs.id
    }
    
    let id: Int?
    let slug: String
    let type: String?
    let owner: User
    let title, body: String
    let pinned: Bool
    let createdAt, updatedAt: String?
    let og_image: String?
    let reply_count: Int?

    enum CodingKeys: String, CodingKey {
        case id
		case slug, type
		case owner
		case title, body
		case pinned
        case createdAt
        case updatedAt
        case reply_count
        case og_image
    }
}
