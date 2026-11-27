//
//  JWTMiddleware.swift
//  OpenFit
//
//  Created by Apprenant 77 on 27/11/2026.
//

import Fluent
import Vapor
import JWT

struct JWTMiddleware: AsyncMiddleware {
    func respond(to request: Request, chainingTo next: any AsyncResponder) async throws -> Response {
        guard let token = request.headers.bearerAuthorization?.token else {
            throw Abort(.unauthorized, reason: APIError.missingToken.errorDescription)
        }

        let payload: UserPayload
        do {
            payload = try request.jwt.verify(token, as: UserPayload.self)
        } catch {
            throw Abort(.unauthorized, reason: APIError.invalidToken.errorDescription)
        }

        guard let userID = payload.userID,
              let user = try await User.find(userID, on: request.db) else {
            throw Abort(.unauthorized, reason: APIError.invalidToken.errorDescription)
        }

        request.auth.login(payload)
        request.auth.login(user)
        return try await next.respond(to: request)
    }
}
