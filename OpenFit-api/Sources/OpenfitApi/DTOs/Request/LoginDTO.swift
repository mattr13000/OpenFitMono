//
//  LoginDTO.swift
//  OpenFit
//
//  Created by Apprenant 77 on 27/11/2026.
//

import Vapor

struct LoginDTO: Content {
    let email: String
    let password: String
}
