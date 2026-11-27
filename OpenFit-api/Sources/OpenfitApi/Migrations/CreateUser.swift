//
//  CreateUser.swift
//  OpenFit
//
//  Created by Apprenant 77 on 27/11/2026.
//

import Fluent

struct CreateUser: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database
            .schema(User.schema)
            .id()
            .field("last_name", .string, .required)
            .field("first_name", .string, .required)
            .field("email", .string, .required)
            .field("password_hash", .string, .required)
            .field("registered_at", .datetime, .required)
            .field("user_updated_at", .datetime)
            .unique(on: "email")
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database
            .schema(User.schema)
            .delete()
    }
}
