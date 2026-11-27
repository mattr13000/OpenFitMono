//
//  JWTMiddlewareTests.swift
//  OpenFit
//
//  Created by Apprenant 77 on 27/11/2026.
//

@testable import OpenfitApi
import VaporTesting
import Testing
import Fluent
import JWT

@Suite("JWT Middleware Tests", .serialized)
struct JWTMiddlewareTests {

    private let protectedPath = "api/test-protected"

    // No 🔒 route exists yet: this one is registered for the tests only.
    private func registerProtectedRoute(on app: Application) {
        app.grouped(JWTMiddleware()).get("api", "test-protected") { req async throws -> String in
            try req.auth.require(User.self).email
        }
    }

    private func expectUnauthorized(
        token: String?,
        reason: APIError,
        app: Application
    ) async throws {
        try await app.testing().test(.GET, protectedPath, beforeRequest: { req in
            if let token {
                req.headers.bearerAuthorization = BearerAuthorization(token: token)
            }
        }, afterResponse: { res async throws in
            #expect(res.status == .unauthorized)
            let body = try res.content.decode(ErrorBody.self)
            #expect(body.reason == reason.errorDescription)
        })
    }

    @Test("GET protected -> 200 with valid token")
    func validToken() async throws {
        try await withTestApp { app in
            registerProtectedRoute(on: app)
            let user = try await app.createUser(email: "alice@test.com")
            let token = try app.generateToken(for: user)

            try await app.testing().test(.GET, protectedPath, beforeRequest: { req in
                req.headers.bearerAuthorization = BearerAuthorization(token: token)
            }, afterResponse: { res async in
                #expect(res.status == .ok)
                #expect(res.body.string == "alice@test.com")
            })
        }
    }

    @Test("GET protected -> 200 with token from login")
    func tokenFromLogin() async throws {
        try await withTestApp { app in
            registerProtectedRoute(on: app)
            try await app.createUser(email: "alice@test.com", password: "password123")

            var token = ""
            try await app.testing().test(.POST, "api/auth/login", beforeRequest: { req in
                try req.content.encode(LoginDTO(email: "alice@test.com", password: "password123"))
            }, afterResponse: { res async throws in
                token = try res.content.decode(AuthDTO.self).token
            })

            try await app.testing().test(.GET, protectedPath, beforeRequest: { req in
                req.headers.bearerAuthorization = BearerAuthorization(token: token)
            }, afterResponse: { res async in
                #expect(res.status == .ok)
            })
        }
    }

    @Test("GET protected -> 401 without token")
    func missingToken() async throws {
        try await withTestApp { app in
            registerProtectedRoute(on: app)
            try await expectUnauthorized(token: nil, reason: .missingToken, app: app)
        }
    }

    @Test("GET protected -> 401 with invalid token")
    func invalidToken() async throws {
        try await withTestApp { app in
            registerProtectedRoute(on: app)
            try await expectUnauthorized(token: "invalid.jwt.token", reason: .invalidToken, app: app)
        }
    }

    @Test("GET protected -> 401 with token signed by another key")
    func wrongSignature() async throws {
        try await withTestApp { app in
            registerProtectedRoute(on: app)
            let user = try await app.createUser()
            let token = try JWTSigner.hs256(key: "another-secret").sign(UserPayload(userID: try user.requireID()))
            try await expectUnauthorized(token: token, reason: .invalidToken, app: app)
        }
    }

    @Test("GET protected -> 401 with expired token")
    func expiredToken() async throws {
        try await withTestApp { app in
            registerProtectedRoute(on: app)
            let user = try await app.createUser()
            let token = try app.generateToken(for: user, expiresAt: Date().addingTimeInterval(-3600))
            try await expectUnauthorized(token: token, reason: .invalidToken, app: app)
        }
    }

    @Test("GET protected -> 401 when user no longer exists")
    func deletedUser() async throws {
        try await withTestApp { app in
            registerProtectedRoute(on: app)
            let user = try await app.createUser()
            let token = try app.generateToken(for: user)
            try await user.delete(on: app.db)
            try await expectUnauthorized(token: token, reason: .invalidToken, app: app)
        }
    }
}
