//
//  TestApp.swift
//  OpenFit
//
//  Created by Apprenant 77 on 27/11/2026.
//

@testable import OpenfitApi
import VaporTesting
import Fluent

// Not named `withApp`: VaporTesting already exports a global `withApp` that skips `configure`.
func withTestApp(_ test: (Application) async throws -> Void) async throws {
    let app = try await Application.make(.testing)
    do {
        try await configure(app)
        try await app.autoMigrate()
        try await test(app)
        try await app.autoRevert()
    } catch {
        try? await app.autoRevert()
        try await app.asyncShutdown()
        throw error
    }
    try await app.asyncShutdown()
}

struct ErrorBody: Decodable {
    let error: Bool
    let reason: String
}
