//
//  AdminToken.swift
//  tourist_hell
//
//  Created by Ruslan on 22.04.2025.
//

import Fluent
import JWT
import Vapor

struct AdminToken: Content, Authenticatable, JWTPayload {
    enum CodingKeys: String, CodingKey {
        case expiration = "exp"
        case isAdmin = "admin"
        case userId = "user"
    }

    // Constants
    let expirationTime: TimeInterval = 60 * 60 * 24

    // Token Data
    var expiration: ExpirationClaim
    var userId: UUID
    var isAdmin: Bool = false

    init(with admin: Admin) throws {
        self.userId = try admin.requireID()
        self.isAdmin = true
        self.expiration = ExpirationClaim(value: Date().addingTimeInterval(expirationTime))
    }

    func verify(using algorithm: some JWTAlgorithm) throws {
        try expiration.verifyNotExpired()
    }
}
