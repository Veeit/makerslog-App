// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let archivments = try? newJSONDecoder().decode(Archivments.self, from: jsonData)

import Foundation

// MARK: - Archivment
struct Archivment: Codable, Identifiable {
    let id, user: Int
    let kind, key: String
    let ephemeral: Bool
    let createdAt: String
    let data: DataClass
    let read: Bool

    enum CodingKeys: String, CodingKey {
        case id, user, kind, key, ephemeral
        case createdAt = "created_at"
        case data, read
    }
}

// MARK: - DataClass
struct DataClass: Codable {
    let key, name, dataDescription, verb: String
    let emoji, color: String
    let progress, order: Int

    enum CodingKeys: String, CodingKey {
        case key, name
        case dataDescription = "description"
        case verb, emoji, color, progress, order
    }
}

typealias Archivments = [Archivment]
