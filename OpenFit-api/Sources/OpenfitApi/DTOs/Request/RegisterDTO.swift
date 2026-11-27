//
//  RegisterDTO.swift
//  OpenFit
//
//  Created by Apprenant 77 on 27/11/2026.
//

import Vapor

struct RegisterDTO: Content {
    let lastName: String
    let firstName: String
    let email: String
    let password: String
    let confirmPassword: String
}

extension RegisterDTO {
    var normalizedEmail: String {
        email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    }

    func validate() throws {
        guard !lastName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw Abort(.unprocessableEntity, reason: APIError.emptyLastName.errorDescription)
        }
        guard !firstName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw Abort(.unprocessableEntity, reason: APIError.emptyFirstName.errorDescription)
        }
        guard normalizedEmail.range(of: #"^[^@\s]+@[^@\s]+\.[^@\s]+$"#, options: .regularExpression) != nil else {
            throw Abort(.unprocessableEntity, reason: APIError.invalidEmail.errorDescription)
        }
        guard password.count >= 8 else {
            throw Abort(.unprocessableEntity, reason: APIError.passwordTooShort.errorDescription)
        }
        guard password == confirmPassword else {
            throw Abort(.unprocessableEntity, reason: APIError.passwordMismatch.errorDescription)
        }
    }

    func toModel(passwordHash: String) -> User {
        User(
            lastName: lastName.trimmingCharacters(in: .whitespacesAndNewlines),
            firstName: firstName.trimmingCharacters(in: .whitespacesAndNewlines),
            email: normalizedEmail,
            passwordHash: passwordHash
        )
    }
}
