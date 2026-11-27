//
//  WeightEntry.swift
//  OpenFit
//
//  Created by Apprenant 77 on 27/11/2026.
//

import Fluent
import Foundation

final class WeightEntry: Model, @unchecked Sendable {
    static let schema = "weight_entries"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "measured_on")
    var measuredOn: Date

    @Field(key: "weight_kg")
    var weightKg: Double

    @Parent(key: "user_id")
    var user: User

    init() {}

    init(id: UUID? = nil, measuredOn: Date, weightKg: Double, userID: UUID) {
        self.id = id
        self.measuredOn = measuredOn
        self.weightKg = weightKg
        self.$user.id = userID
    }
}
