//
//  Activity.swift
//  OpenFit
//
//  Created by Apprenant 77 on 27/11/2026.
//

import Fluent
import Foundation

final class Activity: Model, @unchecked Sendable {
    static let schema = "activities"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "performed_at")
    var performedAt: Date

    @Field(key: "duration_minutes")
    var durationMinutes: Int

    @OptionalField(key: "calories_burned")
    var caloriesBurned: Int?

    @OptionalField(key: "activity_notes")
    var notes: String?

    @Parent(key: "user_id")
    var user: User

    @Parent(key: "activity_type_id")
    var activityType: ActivityType

    init() {}

    init(id: UUID? = nil,
         performedAt: Date,
         durationMinutes: Int,
         caloriesBurned: Int? = nil,
         notes: String? = nil,
         userID: UUID,
         activityTypeID: UUID) {
        self.id = id
        self.performedAt = performedAt
        self.durationMinutes = durationMinutes
        self.caloriesBurned = caloriesBurned
        self.notes = notes
        self.$user.id = userID
        self.$activityType.id = activityTypeID
    }
}
