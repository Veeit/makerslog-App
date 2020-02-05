// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let notification = try? newJSONDecoder().decode(Notification.self, from: jsonData)

import Foundation

// MARK: - NotificationElement
struct NotificationElement: Codable {
    let id: Int
    let key: String
    let read: Bool
    let verb: String
    let recipient, actor: Actor
    let target: Target
    let broadcastLink: String?
    let created, targetType: String

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
    let username: Username
    let firstName: FirstName
    let lastName: LastName
    let status: String?
    let actorDescription: Description
    let verified, actorPrivate: Bool
    let avatar: String
    let streak: Int
    let timezone: Timezone
    let weekTda: Int
    let twitterHandle: TwitterHandle
    let instagramHandle: InstagramHandle
    let productHuntHandle: ProductHuntHandle
    let githubHandle: String
    let telegramHandle: TelegramHandle
    let nomadlistHandle: String?
    let bmcHandle: Handle
    let header: String?
    let isStaff, donor: Bool
    let shipstreamsHandle: Handle
    let website: String
    let tester, isLive, digest, gold: Bool
    let accent: Accent
    let makerScore: Int
    let darkMode, weekendsOff, hardcoreMode: Bool

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

enum Accent: String, Codable {
    case db5855 = "#db5855"
    case the47E0A0 = "#47E0A0"
}

enum Description: String, Codable {
    case aspiringComputerMagician = "✨ aspiring computer magician \u{1f3a9}"
    case developerOfINEZTheNewBudgetPlanner = "developer of INEZ - the new budget planner."
    case myAsksWhyTooMuch = "\u{1f495}my\u{1f415}\u{1f408}\u{1f420} | Asks \"why?\" too much"
    case realLifeCarmenSandiego = "Real-life Carmen Sandiego (\u{1f1fa}\u{1f1e6}|\u{1f1f7}\u{1f1fa}|\u{1f1e8}\u{1f1e6})"
}

enum Handle: String, Codable {
    case carlpoppa = "carlpoppa"
    case empty = ""
    case fiiv = "fiiv"
    case statalog = "Statalog"
}

enum FirstName: String, Codable {
    case carl = "Carl"
    case mike = "Mike"
    case veit = "Veit"
    case vicki = "Vicki"
}

enum InstagramHandle: String, Codable {
    case empty = ""
    case poppacalypse = "poppacalypse"
    case voxelsvoxel = "voxelsvoxel"
}

enum LastName: String, Codable {
    case langer = "Langer"
    case poppa = "Poppa"
    case progl = "Progl"
    case timofiiv = "Timofiiv"
}

enum ProductHuntHandle: String, Codable {
    case chiefoopsmaster = "chiefoopsmaster"
    case empty = ""
    case mtimofiiv = "mtimofiiv"
}

enum TelegramHandle: String, Codable {
    case empty = ""
    case fiiva = "fiiva"
    case veitpro = "Veitpro"
}

enum Timezone: String, Codable {
    case americaNewYork = "America/New_York"
    case asiaUlaanbaatar = "Asia/Ulaanbaatar"
    case europeBerlin = "Europe/Berlin"
    case europeRome = "Europe/Rome"
}

enum TwitterHandle: String, Codable {
    case mtimofiiv = "mtimofiiv"
    case poppacalypse = "poppacalypse"
    case vickiLanger = "Vicki_langer"
    case voxelVoxels = "VoxelVoxels"
}

enum Username: String, Codable {
    case fiiv = "fiiv"
    case poppacalypse = "poppacalypse"
    case veitpro = "veitpro"
    case vickilanger = "vickilanger"
}

// MARK: - Target
struct Target: Codable {
    let id: Int
    let slug, type: String?
    let owner: Actor?
    let title, body: String?
    let pinned: Bool?
    let createdAt, updatedAt: String
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


