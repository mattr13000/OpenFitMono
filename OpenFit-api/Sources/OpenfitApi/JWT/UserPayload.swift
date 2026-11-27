//
//  UserPayload.swift
//  OpenFit
//
//  Created by Apprenant 77 on 27/11/2026.
//

import Foundation
import Vapor
import JWT

struct UserPayload: JWTPayload, Authenticatable {
    static let lifetime: TimeInterval = 7 * 24 * 3600

    var subject: SubjectClaim
    var expiration: ExpirationClaim

    enum CodingKeys: String, CodingKey {
        case subject = "sub"
        case expiration = "exp"
    }

    init(userID: UUID) {
        subject = SubjectClaim(value: userID.uuidString)
        expiration = ExpirationClaim(value: Date().addingTimeInterval(Self.lifetime))
    }

    var userID: UUID? {
        UUID(uuidString: subject.value)
    }

    func verify(using signer: JWTSigner) throws {
        try expiration.verifyNotExpired()
    }
}
