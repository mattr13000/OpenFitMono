//
//  CreateGoal.swift
//  OpenFit
//
//  Created by Apprenant 77 on 27/11/2026.
//

import Fluent

struct CreateGoal: AsyncMigration {
    func prepare(on database: any Database) async throws {
        let goalType = try await database
            .enum("goal_type")
            .case("calories_consumed")
            .case("protein")
            .case("carbs")
            .case("fat")
            .case("calories_burned")
            .case("activity_duration")
            .case("workout_count")
            .create()

        let goalPeriod = try await database
            .enum("goal_period")
            .case("day")
            .case("week")
            .case("workout")
            .create()

        let calculationMode = try await database
            .enum("calculation_mode")
            .case("manual")
            .case("automatic")
            .create()

        try await database
            .schema(Goal.schema)
            .id()
            .field("goal_type", goalType, .required)
            .field("goal_period", goalPeriod, .required)
            .field("target_value", .double, .required)
            .field("calculation_mode", calculationMode, .required)
            .field("start_date", .date, .required)
            .field("end_date", .date)
            .field("goal_is_active", .bool, .required)
            .field("user_id", .uuid, .required, .references(User.schema, "id", onDelete: .cascade))
            .field("activity_category_id", .uuid, .references(ActivityCategory.schema, "id"))
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database
            .schema(Goal.schema)
            .delete()

        try await database.enum("goal_type").delete()
        try await database.enum("goal_period").delete()
        try await database.enum("calculation_mode").delete()
    }
}
