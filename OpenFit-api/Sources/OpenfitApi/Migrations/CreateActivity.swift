//
//  CreateActivity.swift
//  OpenFit
//
//  Created by Apprenant 77 on 27/11/2026.
//

import Fluent

struct CreateActivity: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database
            .schema(Activity.schema)
            .id()
            .field("performed_at", .datetime, .required)
            .field("duration_minutes", .int, .required)
            .field("calories_burned", .int)
            .field("activity_notes", .string)
            .field("user_id", .uuid, .required, .references(User.schema, "id", onDelete: .cascade))
            .field("activity_type_id", .uuid, .required, .references(ActivityType.schema, "id"))
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database
            .schema(Activity.schema)
            .delete()
    }
}
