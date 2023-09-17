//
//  Run.swift
//  IJustFeltLikeRunninguh
//
//  Created by Phillip Williams on 9/15/23.
//

import Foundation
import SwiftData

@Model
class Run {
    // @Attribute(.unique)
    var id = ""

    // audit fields
    var createdAt: Date
    // var createdBy: String
    // var updatedAt: Date
    // var updatedBy: String

    var date: Date
    var distance: String
    var time: String
    var averagePace: String
    var averageHeartRate: String
    var runFormat: String

    var weather: String
    var mood: String

    init(
        id: String = UUID().uuidString,
        createdAt: Date = .now,
        date: Date = .now,
        distance: String = "",
        time: String = "",
        averagePace: String = "",
        averageHeartRate: String = "",
        runFormat: String = "",
        weather: String = "",
        mood: String = ""
    ) {
        self.id = id
        self.createdAt = createdAt
        self.date = date
        self.distance = distance
        self.time = time
        self.averagePace = averagePace
        self.averageHeartRate = averageHeartRate
        self.runFormat = runFormat
        self.weather = weather
        self.mood = mood
    }
}

// enum WeatherType: String, Codable, CaseIterable {
//    case Unknown, Cold, Wet, Fair, Hot
// }
//
// enum MoodType: String, Codable, CaseIterable {
//    case Unknown, Terrible, Bad, Okay, Good, Great
// }
