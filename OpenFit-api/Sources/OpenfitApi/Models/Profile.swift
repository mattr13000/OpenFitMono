//
//  Profile.swift
//  OpenFit
//
//  Created by Apprenant 77 on 27/11/2026.
//

import Fluent
import Foundation

final class Profile: Model, @unchecked Sendable {
    static let schema = "profiles"

    @ID(key: .id)
    var id: UUID?

    @OptionalField(key: "birth_date")
    var birthDate: Date?

    @OptionalEnum(key: "sex")
    var sex: Sex?

    @OptionalField(key: "height_cm")
    var heightCm: Int?

    @OptionalEnum(key: "activity_level")
    var activityLevel: ActivityLevel?

    @OptionalEnum(key: "health_goal")
    var healthGoal: HealthGoal?

    @Parent(key: "user_id")
    var user: User

    init() {}

    init(id: UUID? = nil,
         birthDate: Date? = nil,
         sex: Sex? = nil,
         heightCm: Int? = nil,
         activityLevel: ActivityLevel? = nil,
         healthGoal: HealthGoal? = nil,
         userID: UUID) {
        self.id = id
        self.birthDate = birthDate
        self.sex = sex
        self.heightCm = heightCm
        self.activityLevel = activityLevel
        self.healthGoal = healthGoal
        self.$user.id = userID
    }
}
