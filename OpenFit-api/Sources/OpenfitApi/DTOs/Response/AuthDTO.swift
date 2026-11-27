//
//  AuthDTO.swift
//  OpenFit
//
//  Created by Apprenant 77 on 27/11/2026.
//

import Vapor

struct AuthDTO: Content {
    let token: String
    let expiresAt: Date
    let user: UserDTO
}
