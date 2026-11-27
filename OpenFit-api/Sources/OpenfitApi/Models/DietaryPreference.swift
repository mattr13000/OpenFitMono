//
//  DietaryPreference.swift
//  OpenFit
//
//  Created by Apprenant 77 on 27/11/2026.
//

import Fluent
import Foundation

final class DietaryPreference: Model, @unchecked Sendable {
    static let schema = "dietary_preferences"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "dietary_preference_label")
    var label: String

    init() {}

    init(id: UUID? = nil, label: String) {
        self.id = id
        self.label = label
    }
}
