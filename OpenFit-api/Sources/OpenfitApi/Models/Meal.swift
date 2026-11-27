//
//  Meal.swift
//  OpenFit
//
//  Created by Apprenant 77 on 27/11/2026.
//

import Fluent
import Foundation

final class Meal: Model, @unchecked Sendable {
    static let schema = "meals"

    @ID(key: .id)
    var id: UUID?

    @Enum(key: "meal_type")
    var mealType: MealType

    @Field(key: "eaten_at")
    var eatenAt: Date

    @OptionalField(key: "meal_notes")
    var notes: String?

    @Parent(key: "user_id")
    var user: User

    @Children(for: \.$meal)
    var items: [MealItem]

    init() {}

    init(id: UUID? = nil,
         mealType: MealType,
         eatenAt: Date,
         notes: String? = nil,
         userID: UUID) {
        self.id = id
        self.mealType = mealType
        self.eatenAt = eatenAt
        self.notes = notes
        self.$user.id = userID
    }
}
