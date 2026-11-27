//
//  Goal.swift
//  OpenFit
//
//  Created by Apprenant 77 on 27/11/2026.
//

import Fluent
import Foundation

final class Goal: Model, @unchecked Sendable {
    static let schema = "goals"

    @ID(key: .id)
    var id: UUID?

    @Enum(key: "goal_type")
    var goalType: GoalType

    @Enum(key: "goal_period")
    var period: GoalPeriod

    @Field(key: "target_value")
    var targetValue: Double

    @Enum(key: "calculation_mode")
    var calculationMode: CalculationMode

    @Field(key: "start_date")
    var startDate: Date

    @OptionalField(key: "end_date")
    var endDate: Date?

    @Field(key: "goal_is_active")
    var isActive: Bool

    @Parent(key: "user_id")
    var user: User

    @OptionalParent(key: "activity_category_id")
    var activityCategory: ActivityCategory?

    init() {}

    init(id: UUID? = nil,
         goalType: GoalType,
         period: GoalPeriod,
         targetValue: Double,
         calculationMode: CalculationMode = .manual,
         startDate: Date,
         endDate: Date? = nil,
         isActive: Bool = true,
         userID: UUID,
         activityCategoryID: UUID? = nil) {
        self.id = id
        self.goalType = goalType
        self.period = period
        self.targetValue = targetValue
        self.calculationMode = calculationMode
        self.startDate = startDate
        self.endDate = endDate
        self.isActive = isActive
        self.$user.id = userID
        self.$activityCategory.id = activityCategoryID
    }
}
