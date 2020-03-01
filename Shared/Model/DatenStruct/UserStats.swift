// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let userStats = try? newJSONDecoder().decode(UserStats.self, from: jsonData)

import Foundation

// MARK: - UserStats
struct UserStats: Codable {
    let remainingTasks, doneToday, tda: Int
    let doneWeek: DoneWeek
    let streak: Int
    let activityTrend: [Int]
    let praiseReceived, followerCount, makerScore, restDayBalance: Int

    enum CodingKeys: String, CodingKey {
        case remainingTasks
        case doneToday
        case tda
        case doneWeek
        case streak
        case activityTrend
        case praiseReceived
        case followerCount
        case makerScore
        case restDayBalance
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
    let data: [Int]
}
