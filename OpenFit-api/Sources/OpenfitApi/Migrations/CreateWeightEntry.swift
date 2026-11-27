//
//  CreateWeightEntry.swift
//  OpenFit
//
//  Created by Apprenant 77 on 27/11/2026.
//

import Fluent

struct CreateWeightEntry: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database
            .schema(WeightEntry.schema)
            .id()
            .field("measured_on", .date, .required)
            .field("weight_kg", .double, .required)
            .field("user_id", .uuid, .required, .references(User.schema, "id", onDelete: .cascade))
            .unique(on: "user_id", "measured_on")
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database
            .schema(WeightEntry.schema)
            .delete()
    }
}
