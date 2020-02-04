// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let addLog = try? newJSONDecoder().decode(AddLog.self, from: jsonData)

import Foundation

// MARK: - AddLog
struct AddLog: Codable {
    let id: Int
    let event: String?
    let done, inProgress: Bool
    let content, createdAt, updatedAt: String
    let dueAt, doneAt: Float?
    let user: User
    let projectSet: [Project]
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

