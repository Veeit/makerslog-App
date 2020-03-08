//
//  logsSocket.swift
//  iOS
//
//  Created by Veit Progl on 07.03.20.
//  Copyright © 2020 Veit Progl. All rights reserved.
//

import Foundation

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let userStats = try? newJSONDecoder().decode(UserStats.self, from: jsonData)

// MARK: - LogsSocket
struct LogsSocket: Codable {
    let type: String
    let payload: Log
}
