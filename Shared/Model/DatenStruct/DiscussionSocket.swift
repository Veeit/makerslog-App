//
//  DiscussionSocket.swift
//  iOS
//
//  Created by Veit Progl on 08.03.20.
//  Copyright © 2020 Veit Progl. All rights reserved.
//

import Foundation

// MARK: - DiscussionSocket
struct DiscussionSocket: Codable {
    let type: String
    let payload: DiscussionResponseElement
}
