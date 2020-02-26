//
//  ProjectStruct.swift
//  Makerlog
//
//  Created by Veit Progl on 21.01.20.
//  Copyright © 2020 Veit Progl. All rights reserved.
//

import Foundation

// swiftlint:disable  identifier_name
// MARK: - Project
struct Project: Codable {
    let user: User
    let products: [Product]
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
