//
//  UserDietaryPreference.swift
//  OpenFit
//
//  Created by Apprenant 77 on 27/11/2026.
//

import Fluent
import Foundation

final class UserDietaryPreference: Model, @unchecked Sendable {
    static let schema = "user_dietary_preferences"

    @ID(key: .id)
    var id: UUID?

    @Parent(key: "user_id")
    var user: User

    @Parent(key: "dietary_preference_id")
    var dietaryPreference: DietaryPreference

    init() {}

    init(id: UUID? = nil, userID: UUID, dietaryPreferenceID: UUID) {
        self.id = id
        self.$user.id = userID
        self.$dietaryPreference.id = dietaryPreferenceID
    }
}
