//
//  APIError.swift
//  OpenFit
//
//  Created by Apprenant 77 on 27/11/2026.
//

import Foundation

enum APIError: LocalizedError {
    case emptyLastName
    case emptyFirstName
    case invalidEmail
    case passwordTooShort
    case passwordMismatch
    case emailAlreadyUsed
    case invalidCredentials
    case missingToken
    case invalidToken

    var errorDescription: String? {
        switch self {
        case .emptyLastName:
            return "Last name is required"
        case .emptyFirstName:
            return "First name is required"
        case .invalidEmail:
            return "Invalid email address"
        case .passwordTooShort:
            return "Password must be at least 8 characters"
        case .passwordMismatch:
            return "Passwords do not match"
        case .emailAlreadyUsed:
            return "This email is already in use"
        case .invalidCredentials:
            return "Invalid email or password"
        case .missingToken:
            return "Missing token"
        case .invalidToken:
            return "Invalid or expired token"
        }
    }
}
