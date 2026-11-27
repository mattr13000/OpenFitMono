//
//  CreateFood.swift
//  OpenFit
//
//  Created by Apprenant 77 on 27/11/2026.
//

import Fluent

struct CreateFood: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database
            .schema(Food.schema)
            .id()
            .field("food_name", .string, .required)
            .field("kcal_per_100g", .double, .required)
            .field("protein_per_100g", .double, .required)
            .field("carbs_per_100g", .double, .required)
            .field("fat_per_100g", .double, .required)
            .field("serving_label", .string)
            .field("serving_weight_g", .double)
            .field("food_created_at", .datetime, .required)
            .field("food_category_id", .uuid, .required, .references(FoodCategory.schema, "id"))
            .field("creator_user_id", .uuid, .references(User.schema, "id", onDelete: .cascade))
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database
            .schema(Food.schema)
            .delete()
    }
}
