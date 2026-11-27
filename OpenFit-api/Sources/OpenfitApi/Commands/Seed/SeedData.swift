//
//  SeedData.swift
//  OpenFit
//
//  Created by Apprenant 77 on 27/11/2026.
//

import Foundation

// Demo dates are relative to the seed day (daysAgo = 0 is today, Europe/Paris).
enum SeedData {
    static let password = "Password123!"

    static let dietaryPreferences = ["Vegetarian", "Vegan", "Lactose-free", "Gluten-free", "Halal"]

    static let activityCategories: [(name: String, types: [String])] = [
        ("Cardio", ["Running", "Cycling", "Swimming", "Rowing"]),
        ("Strength training", ["Weightlifting", "Bodyweight training"]),
        ("Yoga", ["Hatha yoga", "Vinyasa yoga"]),
        ("Walking", ["Brisk walking", "Hiking"]),
    ]

    static let foodCategories = [
        "Fruits", "Vegetables", "Meat", "Fish", "Grains",
        "Dairy", "Eggs", "Legumes", "Nuts and seeds", "Prepared dishes",
    ]

    struct FoodTemplate {
        let name: String
        let kcal: Double
        let protein: Double
        let carbs: Double
        let fat: Double
        var serving: (label: String, weightG: Double)? = nil
        let category: String
        var creatorEmail: String? = nil
    }

    static let foods: [FoodTemplate] = [
        .init(name: "Roast chicken", kcal: 165, protein: 31, carbs: 0, fat: 3.6, category: "Meat"),
        .init(name: "Beef steak", kcal: 217, protein: 26.1, carbs: 0, fat: 12.3, category: "Meat"),
        .init(name: "Salmon fillet", kcal: 208, protein: 20.4, carbs: 0, fat: 13.4, category: "Fish"),
        .init(name: "Canned tuna in water", kcal: 116, protein: 25.5, carbs: 0, fat: 0.8, category: "Fish"),
        .init(name: "Egg", kcal: 143, protein: 12.6, carbs: 0.7, fat: 9.5, serving: ("egg", 50), category: "Eggs"),
        .init(name: "White rice, cooked", kcal: 130, protein: 2.7, carbs: 28.2, fat: 0.3, category: "Grains"),
        .init(name: "Wholemeal pasta, cooked", kcal: 149, protein: 5.8, carbs: 30.1, fat: 0.9, category: "Grains"),
        .init(name: "Wholemeal bread", kcal: 247, protein: 13, carbs: 41, fat: 3.4, serving: ("slice", 35), category: "Grains"),
        .init(name: "Rolled oats", kcal: 379, protein: 13.2, carbs: 67.7, fat: 6.5, category: "Grains"),
        .init(name: "Banana", kcal: 89, protein: 1.1, carbs: 22.8, fat: 0.3, serving: ("banana", 120), category: "Fruits"),
        .init(name: "Apple", kcal: 52, protein: 0.3, carbs: 13.8, fat: 0.2, serving: ("apple", 180), category: "Fruits"),
        .init(name: "Orange", kcal: 47, protein: 0.9, carbs: 11.8, fat: 0.1, serving: ("orange", 150), category: "Fruits"),
        .init(name: "Broccoli, steamed", kcal: 35, protein: 2.4, carbs: 7.2, fat: 0.4, category: "Vegetables"),
        .init(name: "Carrot", kcal: 41, protein: 0.9, carbs: 9.6, fat: 0.2, category: "Vegetables"),
        .init(name: "Green salad", kcal: 15, protein: 1.4, carbs: 2.9, fat: 0.2, category: "Vegetables"),
        .init(name: "Plain yogurt", kcal: 61, protein: 3.5, carbs: 4.7, fat: 3.3, serving: ("pot", 125), category: "Dairy"),
        .init(name: "Semi-skimmed milk", kcal: 46, protein: 3.3, carbs: 4.8, fat: 1.5, serving: ("glass", 250), category: "Dairy"),
        .init(name: "Emmental cheese", kcal: 380, protein: 28.5, carbs: 0, fat: 29.7, category: "Dairy"),
        .init(name: "Red lentils, cooked", kcal: 116, protein: 9, carbs: 20.1, fat: 0.4, category: "Legumes"),
        .init(name: "Chickpeas, cooked", kcal: 164, protein: 8.9, carbs: 27.4, fat: 2.6, category: "Legumes"),
        .init(name: "Almonds", kcal: 579, protein: 21.2, carbs: 21.6, fat: 49.9, category: "Nuts and seeds"),
        .init(name: "Olive oil", kcal: 884, protein: 0, carbs: 0, fat: 100, serving: ("tablespoon", 13.5), category: "Nuts and seeds"),
        .init(name: "Homemade lentil curry", kcal: 128, protein: 6.8, carbs: 15.2, fat: 4.1, serving: ("bowl", 300),
              category: "Prepared dishes", creatorEmail: "ines.petit@example.com"),
        .init(name: "Protein shake (brand X)", kcal: 380, protein: 75, carbs: 8, fat: 5, serving: ("scoop", 30),
              category: "Prepared dishes", creatorEmail: "hugo.bernard@example.com"),
    ]

    struct ProfileTemplate {
        let birthDate: (year: Int, month: Int, day: Int)
        let sex: Sex
        let heightCm: Int
        let activityLevel: ActivityLevel
        let healthGoal: HealthGoal
    }

    struct UserTemplate {
        let lastName: String
        let firstName: String
        let email: String
        let registered: (daysAgo: Int, hour: Int, minute: Int)
        var profile: ProfileTemplate? = nil
        var dietaryPreferences: [String] = []
        var weights: [(daysAgo: Int, kg: Double)] = []
    }

    static let users: [UserTemplate] = [
        .init(lastName: "Martin", firstName: "Lea", email: "lea.martin@example.com", registered: (24, 8, 15),
              profile: .init(birthDate: (1994, 3, 12), sex: .female, heightCm: 168, activityLevel: .moderate, healthGoal: .weightLoss),
              dietaryPreferences: ["Lactose-free"],
              weights: [(23, 71.4), (16, 70.9), (9, 70.5), (2, 70.1)]),
        .init(lastName: "Bernard", firstName: "Hugo", email: "hugo.bernard@example.com", registered: (20, 19, 40),
              profile: .init(birthDate: (1989, 7, 30), sex: .male, heightCm: 182, activityLevel: .active, healthGoal: .muscleGain),
              weights: [(19, 78), (5, 78.6)]),
        .init(lastName: "Petit", firstName: "Ines", email: "ines.petit@example.com", registered: (13, 12, 5),
              profile: .init(birthDate: (2001, 11, 2), sex: .female, heightCm: 160, activityLevel: .light, healthGoal: .maintenance),
              dietaryPreferences: ["Vegetarian", "Gluten-free"],
              weights: [(12, 55.2)]),
        .init(lastName: "Durand", firstName: "Malik", email: "malik.durand@example.com", registered: (5, 21, 30),
              dietaryPreferences: ["Halal"]),
    ]

    struct MealTemplate {
        let email: String
        let type: MealType
        let eatenAt: (daysAgo: Int, hour: Int, minute: Int)
        var notes: String? = nil
        let items: [(food: String, quantity: Double, unit: QuantityUnit)]
    }

    static let meals: [MealTemplate] = [
        .init(email: "lea.martin@example.com", type: .breakfast, eatenAt: (1, 7, 30),
              items: [("Rolled oats", 50, .g), ("Banana", 1, .serving), ("Almonds", 15, .g)]),
        .init(email: "lea.martin@example.com", type: .lunch, eatenAt: (1, 12, 30),
              items: [("Roast chicken", 120, .g), ("White rice, cooked", 150, .g), ("Broccoli, steamed", 150, .g), ("Olive oil", 1, .serving)]),
        .init(email: "lea.martin@example.com", type: .snack, eatenAt: (1, 16, 0),
              items: [("Apple", 1, .serving)]),
        .init(email: "lea.martin@example.com", type: .dinner, eatenAt: (1, 19, 45), notes: "Light dinner",
              items: [("Egg", 2, .serving), ("Green salad", 80, .g), ("Wholemeal bread", 1, .serving)]),
        .init(email: "lea.martin@example.com", type: .breakfast, eatenAt: (0, 7, 20),
              items: [("Wholemeal bread", 2, .serving), ("Orange", 1, .serving)]),
        .init(email: "lea.martin@example.com", type: .lunch, eatenAt: (0, 12, 45),
              items: [("Salmon fillet", 130, .g), ("Wholemeal pasta, cooked", 180, .g)]),
        .init(email: "hugo.bernard@example.com", type: .breakfast, eatenAt: (1, 6, 45),
              items: [("Egg", 3, .serving), ("Wholemeal bread", 2, .serving), ("Semi-skimmed milk", 1, .serving)]),
        .init(email: "hugo.bernard@example.com", type: .lunch, eatenAt: (1, 13, 0), notes: "After training",
              items: [("Beef steak", 200, .g), ("White rice, cooked", 250, .g), ("Carrot", 100, .g)]),
        .init(email: "hugo.bernard@example.com", type: .snack, eatenAt: (1, 17, 30),
              items: [("Protein shake (brand X)", 1, .serving), ("Banana", 1, .serving)]),
        .init(email: "hugo.bernard@example.com", type: .dinner, eatenAt: (1, 20, 30),
              items: [("Canned tuna in water", 140, .g), ("Chickpeas, cooked", 200, .g), ("Emmental cheese", 30, .g)]),
        .init(email: "ines.petit@example.com", type: .lunch, eatenAt: (1, 12, 15),
              items: [("Homemade lentil curry", 1, .serving), ("Plain yogurt", 1, .serving)]),
        .init(email: "ines.petit@example.com", type: .dinner, eatenAt: (1, 19, 30),
              items: [("Red lentils, cooked", 200, .g), ("Carrot", 120, .g)]),
    ]

    struct ActivityTemplate {
        let email: String
        let type: String
        let performedAt: (daysAgo: Int, hour: Int, minute: Int)
        let durationMinutes: Int
        let caloriesBurned: Int?
        var notes: String? = nil
    }

    static let activities: [ActivityTemplate] = [
        .init(email: "lea.martin@example.com", type: "Running", performedAt: (7, 18, 0), durationMinutes: 35, caloriesBurned: 330),
        .init(email: "lea.martin@example.com", type: "Hatha yoga", performedAt: (5, 7, 0), durationMinutes: 45, caloriesBurned: 150),
        .init(email: "lea.martin@example.com", type: "Running", performedAt: (3, 10, 0), durationMinutes: 40, caloriesBurned: 380, notes: "Long run"),
        .init(email: "lea.martin@example.com", type: "Brisk walking", performedAt: (1, 12, 0), durationMinutes: 30, caloriesBurned: nil, notes: "Calories not entered"),
        .init(email: "lea.martin@example.com", type: "Cycling", performedAt: (0, 6, 30), durationMinutes: 50, caloriesBurned: 420),
        .init(email: "hugo.bernard@example.com", type: "Weightlifting", performedAt: (7, 19, 0), durationMinutes: 60, caloriesBurned: 280, notes: "Legs"),
        .init(email: "hugo.bernard@example.com", type: "Weightlifting", performedAt: (5, 19, 0), durationMinutes: 65, caloriesBurned: 300, notes: "Upper body"),
        .init(email: "hugo.bernard@example.com", type: "Rowing", performedAt: (3, 9, 30), durationMinutes: 25, caloriesBurned: 240),
        .init(email: "hugo.bernard@example.com", type: "Weightlifting", performedAt: (1, 11, 30), durationMinutes: 70, caloriesBurned: 320, notes: "Full body"),
        .init(email: "ines.petit@example.com", type: "Vinyasa yoga", performedAt: (4, 8, 0), durationMinutes: 60, caloriesBurned: 210),
        .init(email: "ines.petit@example.com", type: "Swimming", performedAt: (2, 17, 0), durationMinutes: 40, caloriesBurned: 360),
        .init(email: "malik.durand@example.com", type: "Hiking", performedAt: (3, 9, 0), durationMinutes: 180, caloriesBurned: 750, notes: "Mountain trail"),
    ]

    struct GoalTemplate {
        let email: String
        let type: GoalType
        let period: GoalPeriod
        let target: Double
        var mode: CalculationMode = .manual
        let startDaysAgo: Int
        var endDaysAgo: Int? = nil
        var isActive = true
        var activityCategory: String? = nil
    }

    static let goals: [GoalTemplate] = [
        .init(email: "lea.martin@example.com", type: .caloriesConsumed, period: .day, target: 1800, mode: .automatic, startDaysAgo: 24),
        .init(email: "lea.martin@example.com", type: .protein, period: .day, target: 110, startDaysAgo: 24),
        .init(email: "lea.martin@example.com", type: .workoutCount, period: .week, target: 3, startDaysAgo: 24),
        .init(email: "lea.martin@example.com", type: .activityDuration, period: .day, target: 30, startDaysAgo: 24, activityCategory: "Cardio"),
        .init(email: "hugo.bernard@example.com", type: .caloriesConsumed, period: .day, target: 2900, startDaysAgo: 20),
        .init(email: "hugo.bernard@example.com", type: .protein, period: .day, target: 150, startDaysAgo: 20),
        .init(email: "hugo.bernard@example.com", type: .carbs, period: .day, target: 350, startDaysAgo: 20),
        .init(email: "hugo.bernard@example.com", type: .fat, period: .day, target: 90, startDaysAgo: 20),
        .init(email: "hugo.bernard@example.com", type: .caloriesBurned, period: .workout, target: 300, startDaysAgo: 20),
        .init(email: "hugo.bernard@example.com", type: .caloriesConsumed, period: .day, target: 2600, mode: .automatic,
              startDaysAgo: 55, endDaysAgo: 21, isActive: false),
        .init(email: "ines.petit@example.com", type: .caloriesConsumed, period: .day, target: 1900, mode: .automatic, startDaysAgo: 13),
        .init(email: "ines.petit@example.com", type: .caloriesBurned, period: .day, target: 500, startDaysAgo: 13),
    ]
}
