//
//  CreateActivityCategory.swift
//  OpenFit
//
//  Created by Apprenant 77 on 27/11/2026.
//

import Fluent

struct CreateActivityCategory: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database
            .schema(ActivityCategory.schema)
            .id()
            .field("activity_category_name", .string, .required)
            .unique(on: "activity_category_name")
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database
            .schema(ActivityCategory.schema)
            .delete()
    }
}
