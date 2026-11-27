//
//  FoodCategory.swift
//  OpenFit
//
//  Created by Apprenant 77 on 27/11/2026.
//

import Fluent
import Foundation

final class FoodCategory: Model, @unchecked Sendable {
    static let schema = "food_categories"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "food_category_name")
    var name: String

    @Children(for: \.$category)
    var foods: [Food]

    init() {}

    init(id: UUID? = nil, name: String) {
        self.id = id
        self.name = name
    }
}
