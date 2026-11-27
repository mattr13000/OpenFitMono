//
//  AuthControllerTests.swift
//  OpenFit
//
//  Created by Apprenant 77 on 27/11/2026.
//

@testable import OpenfitApi
import VaporTesting
import Testing
import Fluent
import JWT

@Suite("AuthController Tests", .serialized)
struct AuthControllerTests {

    private func registerDTO(
        lastName: String = "Martin",
        firstName: String = "Alice",
        email: String = "alice@test.com",
        password: String = "password123",
        confirmPassword: String? = nil
    ) -> RegisterDTO {
        RegisterDTO(
            lastName: lastName,
            firstName: firstName,
            email: email,
            password: password,
            confirmPassword: confirmPassword ?? password
        )
    }

    private func expectRegisterRejected(
        _ dto: RegisterDTO,
        status: HTTPStatus,
        reason: APIError,
        app: Application
    ) async throws {
        try await app.testing().test(.POST, "api/auth/register", beforeRequest: { req in
            try req.content.encode(dto)
        }, afterResponse: { res async throws in
            #expect(res.status == status)
            let body = try res.content.decode(ErrorBody.self)
            #expect(body.reason == reason.errorDescription)
        })
    }

    @Test("POST /api/auth/register -> 201")
    func registerSuccess() async throws {
        try await withTestApp { app in
            let dto = registerDTO(lastName: "  Martin ", email: "  Alice@Test.COM ")

            try await app.testing().test(.POST, "api/auth/register", beforeRequest: { req in
                try req.content.encode(dto)
            }, afterResponse: { res async throws in
                #expect(res.status == .created)
                #expect(!res.body.string.contains("password"))
                let user = try res.content.decode(UserDTO.self)
                #expect(user.email == "alice@test.com")
                #expect(user.lastName == "Martin")
                #expect(user.firstName == "Alice")
            })
        }
    }

    @Test("POST /api/auth/register -> password stored hashed")
    func registerHashesPassword() async throws {
        try await withTestApp { app in
            try await app.testing().test(.POST, "api/auth/register", beforeRequest: { req in
                try req.content.encode(registerDTO())
            }, afterResponse: { res async in
                #expect(res.status == .created)
            })

            let user = try #require(try await User.query(on: app.db).filter(\.$email == "alice@test.com").first())
            #expect(user.passwordHash != "password123")
            #expect(try Bcrypt.verify("password123", created: user.passwordHash))
        }
    }

    @Test("POST /api/auth/register -> 409 email already used")
    func registerEmailAlreadyUsed() async throws {
        try await withTestApp { app in
            try await app.createUser(email: "alice@test.com")
            try await expectRegisterRejected(
                registerDTO(email: "ALICE@test.com"),
                status: .conflict,
                reason: .emailAlreadyUsed,
                app: app
            )
        }
    }

    @Test("POST /api/auth/register -> 422 invalid email")
    func registerInvalidEmail() async throws {
        try await withTestApp { app in
            try await expectRegisterRejected(
                registerDTO(email: "alice.test.com"),
                status: .unprocessableEntity,
                reason: .invalidEmail,
                app: app
            )
        }
    }

    @Test("POST /api/auth/register -> 422 password too short")
    func registerPasswordTooShort() async throws {
        try await withTestApp { app in
            try await expectRegisterRejected(
                registerDTO(password: "1234567"),
                status: .unprocessableEntity,
                reason: .passwordTooShort,
                app: app
            )
        }
    }

    @Test("POST /api/auth/register -> 422 passwords do not match")
    func registerPasswordMismatch() async throws {
        try await withTestApp { app in
            try await expectRegisterRejected(
                registerDTO(password: "password123", confirmPassword: "password124"),
                status: .unprocessableEntity,
                reason: .passwordMismatch,
                app: app
            )
        }
    }

    @Test("POST /api/auth/register -> 422 empty names")
    func registerEmptyNames() async throws {
        try await withTestApp { app in
            try await expectRegisterRejected(
                registerDTO(lastName: "   "),
                status: .unprocessableEntity,
                reason: .emptyLastName,
                app: app
            )
            try await expectRegisterRejected(
                registerDTO(firstName: ""),
                status: .unprocessableEntity,
                reason: .emptyFirstName,
                app: app
            )
        }
    }

    @Test("POST /api/auth/login -> 200 + token")
    func loginSuccess() async throws {
        try await withTestApp { app in
            let user = try await app.createUser(email: "alice@test.com", password: "password123")

            try await app.testing().test(.POST, "api/auth/login", beforeRequest: { req in
                try req.content.encode(LoginDTO(email: " Alice@Test.com ", password: "password123"))
            }, afterResponse: { res async throws in
                #expect(res.status == .ok)
                let auth = try res.content.decode(AuthDTO.self)
                #expect(!auth.token.isEmpty)
                #expect(auth.user.userId == user.id)
                #expect(auth.expiresAt > Date().addingTimeInterval(UserPayload.lifetime - 60))

                let payload = try app.jwt.signers.verify(auth.token, as: UserPayload.self)
                #expect(payload.userID == user.id)
            })
        }
    }

    @Test("POST /api/auth/login -> 401 wrong password")
    func loginWrongPassword() async throws {
        try await withTestApp { app in
            try await app.createUser(email: "alice@test.com", password: "password123")

            try await app.testing().test(.POST, "api/auth/login", beforeRequest: { req in
                try req.content.encode(LoginDTO(email: "alice@test.com", password: "wrongpassword"))
            }, afterResponse: { res async throws in
                #expect(res.status == .unauthorized)
                let body = try res.content.decode(ErrorBody.self)
                #expect(body.reason == APIError.invalidCredentials.errorDescription)
            })
        }
    }

    @Test("POST /api/auth/login -> 401 unknown email")
    func loginUnknownEmail() async throws {
        try await withTestApp { app in
            try await app.testing().test(.POST, "api/auth/login", beforeRequest: { req in
                try req.content.encode(LoginDTO(email: "nobody@test.com", password: "password123"))
            }, afterResponse: { res async throws in
                #expect(res.status == .unauthorized)
                let body = try res.content.decode(ErrorBody.self)
                #expect(body.reason == APIError.invalidCredentials.errorDescription)
            })
        }
    }
}
