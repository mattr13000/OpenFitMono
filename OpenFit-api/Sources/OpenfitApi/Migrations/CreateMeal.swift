//
//  CreateMeal.swift
//  OpenFit
//
//  Created by Apprenant 77 on 27/11/2026.
//

import Fluent

struct CreateMeal: AsyncMigration {
    func prepare(on database: any Database) async throws {
        let mealType = try await database
            .enum("meal_type")
            .case("breakfast")
            .case("lunch")
            .case("dinner")
            .case("snack")
            .create()

        try await database
            .schema(Meal.schema)
            .id()
            .field("meal_type", mealType, .required)
            .field("eaten_at", .datetime, .required)
            .field("meal_notes", .string)
            .field("user_id", .uuid, .required, .references(User.schema, "id", onDelete: .cascade))
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database
            .schema(Meal.schema)
            .delete()

        try await database.enum("meal_type").delete()
    }
}
