// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let userStats = try? newJSONDecoder().decode(UserStats.self, from: jsonData)

import Foundation

// MARK: - UserStats
//swiftlint:disable all
struct UserStats: Codable {
    let remaining_tasks, done_today, tda: Int
    let done_week: DoneWeek
    let streak: Int
    let activity_trend: [Double]
    let praise_received, follower_count, maker_score, rest_day_balance: Int

    enum CodingKeys: String, CodingKey {
        case remaining_tasks
        case done_today
        case tda
        case done_week
        case streak
        case activity_trend
        case praise_received
        case follower_count
        case maker_score
        case rest_day_balance
    }
}

// MARK: - DoneWeek
struct DoneWeek: Codable {
    let labels: [String]
    let datasets: [Dataset]
}

// MARK: - Dataset
struct Dataset: Codable {
    let label, backgroundColor: String
    let data: [Float]
}

