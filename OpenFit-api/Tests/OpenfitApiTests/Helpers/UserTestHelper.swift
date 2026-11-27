//
//  UserTestHelper.swift
//  OpenFit
//
//  Created by Apprenant 77 on 27/11/2026.
//

@testable import OpenfitApi
import Vapor
import Fluent
import JWT

extension Application {
    @discardableResult
    func createUser(
        lastName: String = "Martin",
        firstName: String = "Alice",
        email: String = "alice@test.com",
        password: String = "password123"
    ) async throws -> User {
        let user = User(
            lastName: lastName,
            firstName: firstName,
            email: email,
            passwordHash: try Bcrypt.hash(password)
        )
        try await user.save(on: self.db)
        return user
    }

    func generateToken(for user: User, expiresAt: Date? = nil) throws -> String {
        var payload = UserPayload(userID: try user.requireID())
        if let expiresAt {
            payload.expiration = ExpirationClaim(value: expiresAt)
        }
        return try self.jwt.signers.sign(payload)
    }
}
