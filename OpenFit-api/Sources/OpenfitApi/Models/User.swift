//
//  User.swift
//  OpenFit
//
//  Created by Apprenant 77 on 27/11/2026.
//

import Fluent
import Foundation

final class User: Model, @unchecked Sendable {
    static let schema = "users"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "last_name")
    var lastName: String

    @Field(key: "first_name")
    var firstName: String

    @Field(key: "email")
    var email: String

    @Field(key: "password_hash")
    var passwordHash: String

    @Field(key: "registered_at")
    var registeredAt: Date

    @OptionalField(key: "user_updated_at")
    var updatedAt: Date?

    init() {}

    init(id: UUID? = nil,
         lastName: String,
         firstName: String,
         email: String,
         passwordHash: String,
         registeredAt: Date = Date(),
         updatedAt: Date? = nil) {
        self.id = id
        self.lastName = lastName
        self.firstName = firstName
        self.email = email
        self.passwordHash = passwordHash
        self.registeredAt = registeredAt
        self.updatedAt = updatedAt
    }
}
