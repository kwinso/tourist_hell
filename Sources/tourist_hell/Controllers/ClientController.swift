//
//  AuthController.swift
//  tourist_hell
//
//  Created by Ruslan on 22.04.2025.
//

import Fluent
import Vapor


struct ClientController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let clients = routes.grouped("clients").grouped(Admin.authenticator())

        clients.get(use: index)
        clients.get(":id", use: get)
    }
    
    
    @Sendable
    func index(req: Request) async throws -> [ClientDTO] {
        let clients = try await Client.query(on: req.db).all()
        
        return clients.map { $0.toDTO() }
    }
    
    @Sendable
    func get(req: Request) async throws -> ClientDTO {
        guard let id = req.parameters.get("id", as: UUID.self) else {
            throw Abort(.badRequest)
        }
        guard let client = try await Client.find(id, on: req.db) else {
            throw Abort(.notFound)
        }
        
        return client.toDTO()
    }
}
