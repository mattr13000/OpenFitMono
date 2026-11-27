//
//  CreateUserDietaryPreference.swift
//  OpenFit
//
//  Created by Apprenant 77 on 27/11/2026.
//

import Fluent

struct CreateUserDietaryPreference: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database
            .schema(UserDietaryPreference.schema)
            .id()
            .field("user_id", .uuid, .required, .references(User.schema, "id", onDelete: .cascade))
            .field("dietary_preference_id", .uuid, .required, .references(DietaryPreference.schema, "id"))
            .unique(on: "user_id", "dietary_preference_id")
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database
            .schema(UserDietaryPreference.schema)
            .delete()
    }
}
