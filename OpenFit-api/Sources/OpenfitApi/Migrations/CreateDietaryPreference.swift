//
//  CreateDietaryPreference.swift
//  OpenFit
//
//  Created by Apprenant 77 on 27/11/2026.
//

import Fluent

struct CreateDietaryPreference: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database
            .schema(DietaryPreference.schema)
            .id()
            .field("dietary_preference_label", .string, .required)
            .unique(on: "dietary_preference_label")
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database
            .schema(DietaryPreference.schema)
            .delete()
    }
}
