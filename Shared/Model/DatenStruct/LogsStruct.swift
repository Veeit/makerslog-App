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
   let results: [Log]
}

struct Log: Codable, Identifiable, Equatable {
	static func == (lhs: Log, rhs: Log) -> Bool {
		return lhs.id == rhs.id
	}

	var id: Int
    let event: String?
    let done, inProgress: Bool
	var content, createdAt, updatedAt: String
    let dueAt, doneAt: String?
	var user: User
    let projectSet: [ProjectSet]
	var praise: Int
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
