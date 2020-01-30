//
//  projectStruct.swift
//  Makerlog
//
//  Created by Veit Progl on 21.01.20.
//  Copyright © 2020 Veit Progl. All rights reserved.
//

import Foundation

// MARK: - Project
struct Project: Codable {
    let user: User
    let products: [Product]
}

// MARK: - Product
struct Product: Codable, Identifiable {
    let id: Int
    let name, slug: String
    let user: Int
    let team: [String]
    let productHunt: String?
    let twitter: String?
    let website: String?
    let projects: [ProjectElement]
    let launched: Bool
    let icon: String?
    let productDescription, createdAt, launchedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, name, slug, user, team
        case productHunt = "product_hunt"
        case twitter, website, projects, launched, icon
        case productDescription = "description"
        case createdAt = "created_at"
        case launchedAt = "launched_at"
    }
}

// MARK: - ProjectElement
struct ProjectElement: Codable {
    let id: Int
    let name: String?
    let projectPrivate: Bool
    let user: Int

    enum CodingKeys: String, CodingKey {
        case id, name
        case projectPrivate = "private"
        case user
    }
}
