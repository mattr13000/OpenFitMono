//
//  ActivityLevel.swift
//  OpenFit
//
//  Created by Apprenant 77 on 27/11/2026.
//

import Foundation

enum ActivityLevel: String, Codable, Sendable {
    case sedentary
    case light
    case moderate
    case active
    case veryActive = "very_active"
}
