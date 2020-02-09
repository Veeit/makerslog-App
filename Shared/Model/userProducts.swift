// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let userProducts = try? newJSONDecoder().decode(UserProducts.self, from: jsonData)

import Foundation

// MARK: - UserProduct
// swiftlint:disable all

struct UserProduct: Codable, Identifiable {
    let id: Int
    let name, slug: String
    let user: Int
    let team: [String]
    let productHunt: String?
    let twitter: String?
    let website: String
    let projects: [ProjectDetails]
    let launched: Bool
    let icon: String
    let userProductDescription, accent, createdAt: String?
    let launchedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, name, slug, user, team
        case productHunt
        case twitter, website, projects, launched, icon
        case userProductDescription
        case accent
        case createdAt
        case launchedAt
    }
}

// MARK: - Project
struct ProjectDetails: Codable {
    let id: Int
    let name: String
    let projectPrivate: Bool?
    let user: Int

    enum CodingKeys: String, CodingKey {
        case id, name
        case projectPrivate
        case user
    }
}

typealias UserProducts = [UserProduct]
