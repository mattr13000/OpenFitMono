//
//  CreateFoodCategory.swift
//  OpenFit
//
//  Created by Apprenant 77 on 27/11/2026.
//

import Fluent

struct CreateFoodCategory: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database
            .schema(FoodCategory.schema)
            .id()
            .field("food_category_name", .string, .required)
            .unique(on: "food_category_name")
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database
            .schema(FoodCategory.schema)
            .delete()
    }
}
