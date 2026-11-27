//
//  ActivityType.swift
//  OpenFit
//
//  Created by Apprenant 77 on 27/11/2026.
//

import Fluent
import Foundation

final class ActivityType: Model, @unchecked Sendable {
    static let schema = "activity_types"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "activity_type_name")
    var name: String

    @Parent(key: "activity_category_id")
    var category: ActivityCategory

    init() {}

    init(id: UUID? = nil, name: String, categoryID: UUID) {
        self.id = id
        self.name = name
        self.$category.id = categoryID
    }
}
