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
    var duration: String
    var averagePace: String
    var averageHeartRate: String?
    var runFormat: String?
    var weather: String?
    var mood: String?

    init(
        id: String = "",
        createdAt: Date = .now,
        date: Date = .now,
        distance: String = "",
        duration: String = "",
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
        self.duration = duration
        self.averagePace = averagePace
        self.averageHeartRate = averageHeartRate
        self.runFormat = runFormat
        self.weather = weather
        self.mood = mood
    }
}
