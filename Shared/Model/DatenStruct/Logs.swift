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
    var description: String?
	var projectSet: [Projects]?
	var praise: Int
    let attachment: String?
    let commentCount: Int
    let og_image: String?

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
        case og_image
        case description
    }
    
    func getDate() -> String {
        var isoDate = doneAt ?? createdAt
        isoDate = "\(isoDate.split(separator: ".")[0])Z"
        
        let dateFormatter = ISO8601DateFormatter()
        let date = dateFormatter.date(from: isoDate) ?? Date()

        let components = Calendar.current.dateComponents([.day, .hour, .minute, .second], from: date, to: Date())
        
        if components.day != nil && components.day ?? 0 >= 1 {
            return "\(components.day ?? 1)d"
        } else if components.hour != nil && components.hour ?? 0 >= 1 {
            return "\(components.hour ?? 1)h"
        } else if components.minute != nil && components.minute ?? 0 >= 1 {
            return "\(components.minute ?? 1)m"
        } else if components.second != nil && components.second ?? 0 >= 1 {
            return "\(components.second ?? 1)s"
        } else {
            return "0s"
        }
    }
}

struct LogsPraise: Codable {
    var total: Int
    var praised: Bool
    var praised_by: [User]
    
    enum CodingKeys: String, CodingKey {
        case total
        case praised
        case praised_by
    }
}
