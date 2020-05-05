//
//  ProductStruct.swift
//  iOS
//
//  Created by Veit Progl on 26.02.20.
//  Copyright © 2020 Veit Progl. All rights reserved.
//

import Foundation
import Combine

// MARK: - Product
//swiftlint:disable identifier_name 
struct Product: Codable, Identifiable {
    let id: Int
    let name, slug: String
    let user: Int
    let team: [Int]?
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
