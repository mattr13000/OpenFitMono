//
//  GoalType.swift
//  OpenFit
//
//  Created by Apprenant 77 on 27/11/2026.
//

import Foundation

enum GoalType: String, Codable, Sendable {
    case caloriesConsumed = "calories_consumed"
    case protein
    case carbs
    case fat
    case caloriesBurned = "calories_burned"
    case activityDuration = "activity_duration"
    case workoutCount = "workout_count"
}
