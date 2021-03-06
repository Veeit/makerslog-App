//
//  meModel.swift
//  Makerlog
//
//  Created by Veit Progl on 27.01.20.
//  Copyright © 2020 Veit Progl. All rights reserved.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let me = try? newJSONDecoder().decode(Me.self, from: jsonData)

import Foundation

typealias UserProducts = [Product]

typealias UserRecentLogs = [Log]

// swiftlint:disable  identifier_name
struct User: Codable {
    let id: Int
    let username, firstName, lastName: String
    let status: String?
    let userDescription: String?
    let verified, userPrivate: Bool
    let avatar: String
    let streak: Int
    let timezone: String
    let weekTda: Float
    let twitterHandle, instagramHandle, productHuntHandle, githubHandle, nomadlistHandle: String?
    let telegramHandle, bmcHandle: String?
    let header: String?
    let isStaff, donor: Bool
    let shipstreamsHandle, website: String?
    let tester, isLive, digest, gold: Bool
    let accent: String
    let makerScore: Int
    let darkMode, weekendsOff, hardcoreMode: Bool
    let email_notifications: Bool
    let og_image: String?

    enum CodingKeys: String, CodingKey {
        case id, username
        case firstName = "first_name"
        case lastName = "last_name"
        case status
        case userDescription = "description"
        case verified
        case userPrivate = "private"
        case avatar, streak, timezone
        case weekTda = "week_tda"
        case twitterHandle = "twitter_handle"
        case instagramHandle = "instagram_handle"
        case productHuntHandle = "product_hunt_handle"
        case githubHandle = "github_handle"
        case telegramHandle = "telegram_handle"
        case nomadlistHandle = "nomadlist_handle"
        case bmcHandle = "bmc_handle"
        case header
        case isStaff = "is_staff"
        case donor
        case shipstreamsHandle = "shipstreams_handle"
        case website, tester
        case isLive = "is_live"
        case digest, gold, accent
        case makerScore = "maker_score"
        case darkMode = "dark_mode"
        case weekendsOff = "weekends_off"
        case hardcoreMode = "hardcore_mode"
        case email_notifications
        case og_image
    }

	mutating func getUserName() -> String {
		if self.firstName != "" && self.lastName != "" {
			return "\(self.firstName) \(self.lastName)"
		} else {
			return self.username
		}
	}
}
