//
//  CreateProfile.swift
//  OpenFit
//
//  Created by Apprenant 77 on 27/11/2026.
//

import Fluent

struct CreateProfile: AsyncMigration {
    func prepare(on database: any Database) async throws {
        let sex = try await database
            .enum("sex")
            .case("male")
            .case("female")
            .case("other")
            .create()

        let activityLevel = try await database
            .enum("activity_level")
            .case("sedentary")
            .case("light")
            .case("moderate")
            .case("active")
            .case("very_active")
            .create()

        let healthGoal = try await database
            .enum("health_goal")
            .case("weight_loss")
            .case("muscle_gain")
            .case("maintenance")
            .create()

        try await database
            .schema(Profile.schema)
            .id()
            .field("birth_date", .date)
            .field("sex", sex)
            .field("height_cm", .int)
            .field("activity_level", activityLevel)
            .field("health_goal", healthGoal)
            .field("user_id", .uuid, .required, .references(User.schema, "id", onDelete: .cascade))
            .unique(on: "user_id")
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database
            .schema(Profile.schema)
            .delete()

        try await database.enum("sex").delete()
        try await database.enum("activity_level").delete()
        try await database.enum("health_goal").delete()
    }
}
