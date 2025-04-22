//
//  CreateFirstAdmin.swift
//  tourist_hell
//
//  Created by Ruslan on 22.04.2025.
//
import Fluent
import Vapor
import FluentSQL

extension Admin {
    struct SeedAdmins: AsyncMigration {
        var name: String { "SeedAdmins" }
        
        func prepare(on database: any Database) async throws {
            let passwordHash = try Bcrypt.hash("admin")
            let admin = Admin(id: UUID(uuidString:"f78be635-cc38-49e6-911f-4d1aeeee1fc8"), username: "admin", passwordHash: passwordHash)
            try await admin.save(on: database)
        }
        
        func revert(on database: any Database) async throws {
            try await Admin.query(on: database).delete()
        }
    }
}
