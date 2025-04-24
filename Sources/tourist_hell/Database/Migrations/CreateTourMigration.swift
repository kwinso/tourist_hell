//
//  CreateAdmins.swift
//  tourist_hell
//
//  Created by Ruslan on 22.04.2025.
//

import Fluent
import Vapor
import FluentSQL

extension Tour {
    struct CreateTour: AsyncMigration {
        var name: String { "CreateTour" }
        
        func prepare(on database: any Database) async throws {
            try await database.schema("tours")
                .id()
                .field("name", .string)
                .field("description", .string)
                .field("closest_tour_date", .date)
                .field("destination_country", .string)
                .field("banner_photo", .string)
                .unique(on: "name")
                .create()
            
        }
        
        func revert(on database: any Database) async throws {
            try await database.schema("tours").delete()
        }
    }
}
