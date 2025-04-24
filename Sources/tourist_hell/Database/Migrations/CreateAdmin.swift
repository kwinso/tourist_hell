//
//  CreateAdmin.swift
//  tourist_hell
//
//  Created by Ruslan on 22.04.2025.
//

import Fluent
import Vapor
import FluentSQL

extension Admin {
    struct CreateAdmin: AsyncMigration {
        var name: String { "CreateAdmin" }
        
        func prepare(on database: any Database) async throws {
            try await database.schema("admins")
                .id()
                .field("username", .string, .required)
                .field("password_hash", .string, .required)
                .unique(on: "username")
                .create()
        }
        
        func revert(on database: any Database) async throws {
            try await database.schema("admins").delete()
        }
    }
}
