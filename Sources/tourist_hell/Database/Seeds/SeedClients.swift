//
//  SeedClients.swift
//  Clientist_hell
//
//  Created by Ruslan on 24.04.2025.
//

import Fluent
import Foundation
import Vapor
import FluentSQL

extension Client {
    struct SeedClients: AsyncMigration {
        var name: String { "SeedClients" }
        
        func prepare(on database: any Database) async throws {
            let clients = [
                Client(
                    name: "One Ok Rock",
                    phoneNumber: "88005553535",
                    age: 30,
                ),
                Client(
                    name: "Bob Dylan",
                    phoneNumber: "89002341254",
                    age: 18
                )
            ]
            
            try await clients.create(on: database)
        }
        
        func revert(on database: any Database) async throws {
            try await Client.query(on: database).delete()
        }
    }
}
