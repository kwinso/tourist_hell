//
//  AuthController.swift
//  tourist_hell
//
//  Created by Ruslan on 22.04.2025.
//

import Fluent
import Vapor

struct ClientTokenResponse: Content {
    var token: String
}

struct AuthController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let auth = routes.grouped("auth")

         auth.grouped(Admin.authenticator()).post("admin", use: self.admin)
    }
    
    
    @Sendable
    func admin(req: Request) async throws -> ClientTokenResponse {
        let admin = try req.auth.require(Admin.self)
        let payload = try AdminToken(with: admin)
        return ClientTokenResponse(token: try await req.jwt.sign(payload))
    }
}
