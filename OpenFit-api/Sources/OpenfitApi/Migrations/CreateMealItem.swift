//
//  CreateMealItem.swift
//  OpenFit
//
//  Created by Apprenant 77 on 27/11/2026.
//

import Fluent

struct CreateMealItem: AsyncMigration {
    func prepare(on database: any Database) async throws {
        let quantityUnit = try await database
            .enum("quantity_unit")
            .case("g")
            .case("serving")
            .create()

        try await database
            .schema(MealItem.schema)
            .id()
            .field("quantity", .double, .required)
            .field("quantity_unit", quantityUnit, .required)
            .field("item_kcal", .double, .required)
            .field("item_protein_g", .double, .required)
            .field("item_carbs_g", .double, .required)
            .field("item_fat_g", .double, .required)
            .field("meal_id", .uuid, .required, .references(Meal.schema, "id", onDelete: .cascade))
            .field("food_id", .uuid, .required, .references(Food.schema, "id"))
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database
            .schema(MealItem.schema)
            .delete()

        try await database.enum("quantity_unit").delete()
    }
}
