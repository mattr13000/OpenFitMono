//
//  CreateActivityType.swift
//  OpenFit
//
//  Created by Apprenant 77 on 27/11/2026.
//

import Fluent

struct CreateActivityType: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database
            .schema(ActivityType.schema)
            .id()
            .field("activity_type_name", .string, .required)
            .field("activity_category_id", .uuid, .required, .references(ActivityCategory.schema, "id"))
            .unique(on: "activity_type_name")
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database
            .schema(ActivityType.schema)
            .delete()
    }
}
