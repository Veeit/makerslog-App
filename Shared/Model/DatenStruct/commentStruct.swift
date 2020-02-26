//
//  commentStruct.swift
//  Makerlog
//
//  Created by Veit Progl on 21.01.20.
//  Copyright © 2020 Veit Progl. All rights reserved.
//

import Foundation

// swiftlint:disable  identifier_name
// MARK: - CommentElement
struct CommentElement: Codable, Identifiable {
    let id, objectID, contentType: Int
    let user: User
    let content, createdAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case objectID = "object_id"
        case contentType = "content_type"
        case user, content
        case createdAt = "created_at"
    }
}

typealias Comment = [CommentElement]
