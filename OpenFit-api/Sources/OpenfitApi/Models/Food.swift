//
//  Food.swift
//  OpenFit
//
//  Created by Apprenant 77 on 27/11/2026.
//

import Fluent
import Foundation

final class Food: Model, @unchecked Sendable {
    static let schema = "foods"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "food_name")
    var name: String

    @Field(key: "kcal_per_100g")
    var kcalPer100g: Double

    @Field(key: "protein_per_100g")
    var proteinPer100g: Double

    @Field(key: "carbs_per_100g")
    var carbsPer100g: Double

    @Field(key: "fat_per_100g")
    var fatPer100g: Double

    @OptionalField(key: "serving_label")
    var servingLabel: String?

    @OptionalField(key: "serving_weight_g")
    var servingWeightG: Double?

    @Field(key: "food_created_at")
    var createdAt: Date

    @Parent(key: "food_category_id")
    var category: FoodCategory

    @OptionalParent(key: "creator_user_id")
    var creator: User?

    init() {}

    init(id: UUID? = nil,
         name: String,
         kcalPer100g: Double,
         proteinPer100g: Double,
         carbsPer100g: Double,
         fatPer100g: Double,
         servingLabel: String? = nil,
         servingWeightG: Double? = nil,
         createdAt: Date = Date(),
         categoryID: UUID,
         creatorID: UUID? = nil) {
        self.id = id
        self.name = name
        self.kcalPer100g = kcalPer100g
        self.proteinPer100g = proteinPer100g
        self.carbsPer100g = carbsPer100g
        self.fatPer100g = fatPer100g
        self.servingLabel = servingLabel
        self.servingWeightG = servingWeightG
        self.createdAt = createdAt
        self.$category.id = categoryID
        self.$creator.id = creatorID
    }
}
