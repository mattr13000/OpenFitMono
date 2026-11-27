//
//  MealItem.swift
//  OpenFit
//
//  Created by Apprenant 77 on 27/11/2026.
//

import Fluent
import Foundation

final class MealItem: Model, @unchecked Sendable {
    static let schema = "meal_items"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "quantity")
    var quantity: Double

    @Enum(key: "quantity_unit")
    var quantityUnit: QuantityUnit

    @Field(key: "item_kcal")
    var kcal: Double

    @Field(key: "item_protein_g")
    var proteinG: Double

    @Field(key: "item_carbs_g")
    var carbsG: Double

    @Field(key: "item_fat_g")
    var fatG: Double

    @Parent(key: "meal_id")
    var meal: Meal

    @Parent(key: "food_id")
    var food: Food

    init() {}

    init(id: UUID? = nil,
         quantity: Double,
         quantityUnit: QuantityUnit,
         kcal: Double,
         proteinG: Double,
         carbsG: Double,
         fatG: Double,
         mealID: UUID,
         foodID: UUID) {
        self.id = id
        self.quantity = quantity
        self.quantityUnit = quantityUnit
        self.kcal = kcal
        self.proteinG = proteinG
        self.carbsG = carbsG
        self.fatG = fatG
        self.$meal.id = mealID
        self.$food.id = foodID
    }
}
