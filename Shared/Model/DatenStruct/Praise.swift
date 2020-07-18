// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let praise = try? newJSONDecoder().decode(Praise.self, from: jsonData)

import Foundation

// MARK: - Praise
struct Praise: Codable {
    let amount, user, objectID, contentType: Int
    let total: Int

    enum CodingKeys: String, CodingKey {
        case amount, user
        case objectID = "object_id"
        case contentType = "content_type"
        case total
    }
}


struct PraiseNew: Codable {
    let praised: Bool
    let total: Int
    let user: User
    
    enum CodingKeys: String, CodingKey {
        case praised
        case total
        case user
    }
}
