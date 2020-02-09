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
    let recipient, actor: Actor
    let target: Target
    let broadcastLink: String?
    let created, targetType: String?

    enum CodingKeys: String, CodingKey {
        case id, key, read, verb, recipient, actor, target
        case broadcastLink
        case created
        case targetType
    }
}

// MARK: - Actor
struct Actor: Codable {
    let id: Int
    let username: String
    let firstName: String?
    let lastName: String?
    let status: String?
    let actorDescription: String?
    let verified, actorPrivate: Bool?
    let avatar: String
    let streak: Int
    let timezone: String
    let weekTda: Int?
    let twitterHandle: String?
    let instagramHandle: String?
    let productHuntHandle: String?
    let githubHandle: String?
    let telegramHandle: String?
    let nomadlistHandle: String?
    let bmcHandle: String?
    let header: String?
    let isStaff, donor: Bool?
    let shipstreamsHandle: String?
    let website: String?
    let tester, isLive, digest, gold: Bool?
    let accent: String
    let makerScore: Int?
    let darkMode, weekendsOff, hardcoreMode: Bool?

    enum CodingKeys: String, CodingKey {
        case id, username
        case firstName
        case lastName
        case status
        case actorDescription
        case verified
        case actorPrivate
        case avatar, streak, timezone
        case weekTda
        case twitterHandle
        case instagramHandle
        case productHuntHandle
        case githubHandle
        case telegramHandle
        case nomadlistHandle
        case bmcHandle
        case header
        case isStaff
        case donor
        case shipstreamsHandle
        case website, tester
        case isLive
        case digest, gold, accent
        case makerScore
        case darkMode
        case weekendsOff
        case hardcoreMode
    }
}

// MARK: - Target
struct Target: Codable {
    let id: Int
    let slug, type: String?
    let owner: Actor?
    let title, body: String?
    let pinned: Bool?
    let createdAt, updatedAt: String?
    let replyCount: Int?
    let event: String?
    let done, inProgress: Bool?
    let content: String?
    let dueAt: String?
    let doneAt: String?
    let user: Actor?
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
        case user
        case projectSet
        case praise, attachment
        case commentCount
    }
}

typealias Notification = [NotificationElement]


