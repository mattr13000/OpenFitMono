//
//  SeedCommand.swift
//  OpenFit
//
//  Created by Apprenant 77 on 27/11/2026.
//

import Vapor
import Fluent

struct SeedCommand: AsyncCommand {
    struct Signature: CommandSignature { }

    var help: String {
        "Reset the database with reference data and demo users."
    }

    func run(using context: CommandContext, signature: Signature) async throws {
        let database = context.application.db
        let days = SeedDays(now: Date())

        context.console.info("Cleaning DB ...")
        try await MealItem.query(on: database).delete()
        try await Meal.query(on: database).delete()
        try await Goal.query(on: database).delete()
        try await Activity.query(on: database).delete()
        try await WeightEntry.query(on: database).delete()
        try await UserDietaryPreference.query(on: database).delete()
        try await Profile.query(on: database).delete()
        try await Food.query(on: database).delete()
        try await User.query(on: database).delete()
        try await ActivityType.query(on: database).delete()
        try await ActivityCategory.query(on: database).delete()
        try await FoodCategory.query(on: database).delete()
        try await DietaryPreference.query(on: database).delete()

        context.console.info("Inserting reference data ...")
        let dietaryPreferences = try await insertDietaryPreferences(on: database)
        let activities = try await insertActivityCategoriesAndTypes(on: database)
        let foodCategories = try await insertFoodCategories(on: database)

        context.console.info("Inserting demo users ...")
        let users = try await insertUsers(dietaryPreferences: dietaryPreferences, days: days, on: database)
        let foods = try await insertFoods(categories: foodCategories, users: users, on: database)
        let mealCount = try await insertMeals(foods: foods, users: users, days: days, on: database)
        try await insertActivities(types: activities.types, users: users, days: days, on: database)
        try await insertGoals(categories: activities.categories, users: users, days: days, on: database)

        context.console.success("Success : \(users.count) users, \(foods.count) foods, \(mealCount) meals, \(SeedData.activities.count) activities, \(SeedData.goals.count) goals")
        context.console.info("Login: lea.martin@example.com / \(SeedData.password)")
    }
}

private struct SeedDays {
    let paris: Calendar
    let utc: Calendar
    let today: Date

    init(now: Date) {
        var paris = Calendar(identifier: .gregorian)
        if #available(iOS 16, *) {
            paris.timeZone = TimeZone(identifier: "Europe/Paris") ?? .gmt
        } else {
            // Fallback on earlier versions
        }
        var utc = Calendar(identifier: .gregorian)
        if #available(iOS 16, *) {
            utc.timeZone = .gmt
        } else {
            // Fallback on earlier versions
        }
        self.paris = paris
        self.utc = utc
        self.today = paris.startOfDay(for: now)
    }

    func dateTime(_ moment: (daysAgo: Int, hour: Int, minute: Int)) throws -> Date {
        guard let day = paris.date(byAdding: .day, value: -moment.daysAgo, to: today),
              let date = paris.date(bySettingHour: moment.hour, minute: moment.minute, second: 0, of: day) else {
            throw Abort(.internalServerError, reason: "Invalid seed date")
        }
        return date
    }

    // DATE columns: midnight UTC of the Paris calendar day.
    func day(daysAgo: Int) throws -> Date {
        guard let day = paris.date(byAdding: .day, value: -daysAgo, to: today) else {
            throw Abort(.internalServerError, reason: "Invalid seed date")
        }
        return try self.day(paris.dateComponents([.year, .month, .day], from: day))
    }

    func day(_ components: DateComponents) throws -> Date {
        guard let date = utc.date(from: components) else {
            throw Abort(.internalServerError, reason: "Invalid seed date")
        }
        return date
    }
}

private extension SeedCommand {
    func id(_ key: String, in ids: [String: UUID]) throws -> UUID {
        guard let id = ids[key] else {
            throw Abort(.internalServerError, reason: "Seed data not found: \(key)")
        }
        return id
    }

    func insertDietaryPreferences(on database: any Database) async throws -> [String: UUID] {
        var ids: [String: UUID] = [:]
        for label in SeedData.dietaryPreferences {
            let preference = DietaryPreference(label: label)
            try await preference.save(on: database)
            ids[label] = try preference.requireID()
        }
        return ids
    }

    func insertActivityCategoriesAndTypes(on database: any Database) async throws -> (categories: [String: UUID], types: [String: UUID]) {
        var categories: [String: UUID] = [:]
        var types: [String: UUID] = [:]
        for template in SeedData.activityCategories {
            let category = ActivityCategory(name: template.name)
            try await category.save(on: database)
            let categoryID = try category.requireID()
            categories[template.name] = categoryID

            for name in template.types {
                let type = ActivityType(name: name, categoryID: categoryID)
                try await type.save(on: database)
                types[name] = try type.requireID()
            }
        }
        return (categories, types)
    }

    func insertFoodCategories(on database: any Database) async throws -> [String: UUID] {
        var ids: [String: UUID] = [:]
        for name in SeedData.foodCategories {
            let category = FoodCategory(name: name)
            try await category.save(on: database)
            ids[name] = try category.requireID()
        }
        return ids
    }

    func insertUsers(dietaryPreferences: [String: UUID], days: SeedDays, on database: any Database) async throws -> [String: UUID] {
        let passwordHash = try Bcrypt.hash(SeedData.password)
        var ids: [String: UUID] = [:]

        for template in SeedData.users {
            let user = User(
                lastName: template.lastName,
                firstName: template.firstName,
                email: template.email,
                passwordHash: passwordHash,
                registeredAt: try days.dateTime(template.registered)
            )
            try await user.save(on: database)
            let userID = try user.requireID()
            ids[template.email] = userID

            if let profile = template.profile {
                let birth = profile.birthDate
                try await Profile(
                    birthDate: try days.day(DateComponents(year: birth.year, month: birth.month, day: birth.day)),
                    sex: profile.sex,
                    heightCm: profile.heightCm,
                    activityLevel: profile.activityLevel,
                    healthGoal: profile.healthGoal,
                    userID: userID
                ).save(on: database)
            }

            for label in template.dietaryPreferences {
                try await UserDietaryPreference(
                    userID: userID,
                    dietaryPreferenceID: try id(label, in: dietaryPreferences)
                ).save(on: database)
            }

            for weight in template.weights {
                try await WeightEntry(
                    measuredOn: try days.day(daysAgo: weight.daysAgo),
                    weightKg: weight.kg,
                    userID: userID
                ).save(on: database)
            }
        }
        return ids
    }

    func insertFoods(categories: [String: UUID], users: [String: UUID], on database: any Database) async throws -> [String: Food] {
        var foods: [String: Food] = [:]
        for template in SeedData.foods {
            let food = Food(
                name: template.name,
                kcalPer100g: template.kcal,
                proteinPer100g: template.protein,
                carbsPer100g: template.carbs,
                fatPer100g: template.fat,
                servingLabel: template.serving?.label,
                servingWeightG: template.serving?.weightG,
                categoryID: try id(template.category, in: categories),
                creatorID: try template.creatorEmail.map { try id($0, in: users) }
            )
            try await food.save(on: database)
            foods[template.name] = food
        }
        return foods
    }

    func insertMeals(foods: [String: Food], users: [String: UUID], days: SeedDays, on database: any Database) async throws -> Int {
        for template in SeedData.meals {
            let meal = Meal(
                mealType: template.type,
                eatenAt: try days.dateTime(template.eatenAt),
                notes: template.notes,
                userID: try id(template.email, in: users)
            )
            try await meal.save(on: database)

            for item in template.items {
                guard let food = foods[item.food] else {
                    throw Abort(.internalServerError, reason: "Seed food not found: \(item.food)")
                }
                let grams: Double
                switch item.unit {
                case .g:
                    grams = item.quantity
                case .serving:
                    guard let servingWeight = food.servingWeightG else {
                        throw Abort(.internalServerError, reason: "\(food.name) has no serving size")
                    }
                    grams = item.quantity * servingWeight
                }

                try await MealItem(
                    quantity: item.quantity,
                    quantityUnit: item.unit,
                    kcal: rounded(food.kcalPer100g * grams / 100),
                    proteinG: rounded(food.proteinPer100g * grams / 100),
                    carbsG: rounded(food.carbsPer100g * grams / 100),
                    fatG: rounded(food.fatPer100g * grams / 100),
                    mealID: try meal.requireID(),
                    foodID: try food.requireID()
                ).save(on: database)
            }
        }
        return SeedData.meals.count
    }

    func insertActivities(types: [String: UUID], users: [String: UUID], days: SeedDays, on database: any Database) async throws {
        for template in SeedData.activities {
            try await Activity(
                performedAt: try days.dateTime(template.performedAt),
                durationMinutes: template.durationMinutes,
                caloriesBurned: template.caloriesBurned,
                notes: template.notes,
                userID: try id(template.email, in: users),
                activityTypeID: try id(template.type, in: types)
            ).save(on: database)
        }
    }

    func insertGoals(categories: [String: UUID], users: [String: UUID], days: SeedDays, on database: any Database) async throws {
        for template in SeedData.goals {
            try await Goal(
                goalType: template.type,
                period: template.period,
                targetValue: template.target,
                calculationMode: template.mode,
                startDate: try days.day(daysAgo: template.startDaysAgo),
                endDate: try template.endDaysAgo.map { try days.day(daysAgo: $0) },
                isActive: template.isActive,
                userID: try id(template.email, in: users),
                activityCategoryID: try template.activityCategory.map { try id($0, in: categories) }
            ).save(on: database)
        }
    }

    func rounded(_ value: Double) -> Double {
        (value * 100).rounded() / 100
    }
}
