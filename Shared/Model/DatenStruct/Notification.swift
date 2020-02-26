// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let notification = try? newJSONDecoder().decode(Notification.self, from: jsonData)

import Foundation

// MARK: - NotificationElement
// swiftlint:disable all
struct NotificationElement: Codable, Identifiable {
    let id: Int
    let key: String
    let read: Bool
    let verb: String
	let targetType: String?
    let recipient, actor: User
    let target: Target?
    let broadcastLink: String?
	let created: String?

    enum CodingKeys: String, CodingKey {
        case id, key, read, verb, recipient, actor
		case target
        case broadcastLink
        case created
        case targetType
    }
}

// MARK: - Target
struct Target: Codable {
    let id: Int
    let slug, type: String?
    let owner: User?
    let title, body: String?
    let pinned: Bool?
    let createdAt, updatedAt: String?
    let replyCount: Int?
    let event: String?
    let done, inProgress: Bool?
    let content: String?
    let dueAt: String?
    let doneAt: String?
//    var user: User?
    let projectSet: [ProjectSet]?
    let praise: Int?
    let attachment: String?
    let commentCount: Int?

    enum CodingKeys: String, CodingKey {
        case id, slug, type, owner, title, body, pinned
        case createdAt
        case updatedAt
        case replyCount
        case event, done
        case inProgress
        case content
        case dueAt
        case doneAt
//        case user
        case projectSet
        case praise, attachment
        case commentCount
    }
}

typealias Notification = [NotificationElement]


