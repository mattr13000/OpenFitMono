//
//  AuthController.swift
//  OpenFit
//
//  Created by Apprenant 77 on 27/11/2026.
//

import Fluent
import Vapor
import JWT

struct AuthController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let auth = routes.grouped("auth")
        auth.post("register", use: register)
        auth.post("login", use: login)
    }

    func register(req: Request) async throws -> Response {
        let dto = try req.content.decode(RegisterDTO.self)
        try dto.validate()

        guard try await User.query(on: req.db).filter(\.$email == dto.normalizedEmail).first() == nil else {
            throw Abort(.conflict, reason: APIError.emailAlreadyUsed.errorDescription)
        }

        let user = dto.toModel(passwordHash: try Bcrypt.hash(dto.password))
        try await user.save(on: req.db)
        return try await user.toDTO().encodeResponse(status: .created, for: req)
    }

    func login(req: Request) async throws -> AuthDTO {
        let dto = try req.content.decode(LoginDTO.self)
        let email = dto.email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()

        guard let user = try await User.query(on: req.db).filter(\.$email == email).first(),
              try Bcrypt.verify(dto.password, created: user.passwordHash) else {
            throw Abort(.unauthorized, reason: APIError.invalidCredentials.errorDescription)
        }

        let payload = UserPayload(userID: try user.requireID())
        return AuthDTO(
            token: try req.jwt.sign(payload),
            expiresAt: payload.expiration.value,
            user: try user.toDTO()
        )
    }
}
