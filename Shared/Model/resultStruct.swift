// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// swiftlint:disable  identifier_name
struct Logs: Codable {
   let count: Int
   let next: String?
   let previous: String?
   let results: [Result]
}

struct Result: Codable, Identifiable {
    let id: Int
    let event: String?
    let done, inProgress: Bool
    let content, createdAt, updatedAt: String
    let dueAt, doneAt: String?
    let user: User
    let projectSet: [ProjectSet]
    let praise: Int
    let attachment: String?
    let commentCount: Int

    enum CodingKeys: String, CodingKey {
        case id, event, done
        case inProgress = "in_progress"
        case content
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case dueAt = "due_at"
        case doneAt = "done_at"
        case user
        case projectSet = "project_set"
        case praise, attachment
        case commentCount = "comment_count"
    }
}

struct User: Codable {
    let id: Int
    let username, firstName, lastName: String
    let status: String?
    let userDescription: String?
    let verified, userPrivate: Bool
    let avatar: String
    let streak: Int
    let timezone: String
    let weekTda: Float
    let twitterHandle, instagramHandle, productHuntHandle, githubHandle: String?
    let telegramHandle, bmcHandle: String?
    let header: String?
    let isStaff, donor: Bool
    let shipstreamsHandle, website: String?
    let tester, isLive, digest, gold: Bool
    let accent: String
    let makerScore: Int
    let darkMode, weekendsOff, hardcoreMode: Bool

    enum CodingKeys: String, CodingKey {
        case id, username
        case firstName = "first_name"
        case lastName = "last_name"
        case status
        case userDescription = "description"
        case verified
        case userPrivate = "private"
        case avatar, streak, timezone
        case weekTda = "week_tda"
        case twitterHandle = "twitter_handle"
        case instagramHandle = "instagram_handle"
        case productHuntHandle = "product_hunt_handle"
        case githubHandle = "github_handle"
        case telegramHandle = "telegram_handle"
        case bmcHandle = "bmc_handle"
        case header
        case isStaff = "is_staff"
        case donor
        case shipstreamsHandle = "shipstreams_handle"
        case website, tester
        case isLive = "is_live"
        case digest, gold, accent
        case makerScore = "maker_score"
        case darkMode = "dark_mode"
        case weekendsOff = "weekends_off"
        case hardcoreMode = "hardcore_mode"
    }
}

struct ProjectSet: Codable, Identifiable {
    let id: Int
    let name: String
    let projectSetPrivate: Bool
    let user: Int

    enum CodingKeys: String, CodingKey {
        case id, name
        case projectSetPrivate = "private"
        case user
    }
}
