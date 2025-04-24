//
//  CreateClient.swift
//  tourist_hell
//
//  Created by Ruslan on 22.04.2025.
//

import Fluent
import Vapor
import FluentSQL

extension Client {
    struct CreateClient: AsyncMigration {
        var name: String { "CreateClient" }
        
        func prepare(on database: any Database) async throws {
            try await database.schema("clients")
                .id()
                .field("name", .string, .required)
                .field("phone_number", .string, .required)
                .field("age", .int, .required)
                .unique(on: "phone_number")
                .create()
        }
        
        func revert(on database: any Database) async throws {
            try await database.schema("clients").delete()
        }
    }
}
