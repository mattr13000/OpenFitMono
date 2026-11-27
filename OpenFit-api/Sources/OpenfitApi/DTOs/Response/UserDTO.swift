//
//  UserDTO.swift
//  OpenFit
//
//  Created by Apprenant 77 on 27/11/2026.
//

import Vapor

struct UserDTO: Content {
    let userId: UUID
    let lastName: String
    let firstName: String
    let email: String
    let registeredAt: Date
}
