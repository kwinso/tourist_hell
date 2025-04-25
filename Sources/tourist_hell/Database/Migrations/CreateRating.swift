//
//  CreateTourRating.swift
//  tourist_hell
//
//  Created by Ruslan on 22.04.2025.
//

import Fluent
import FluentSQL
import Vapor

extension Rating {
    struct CreateRating: AsyncMigration {
        var name: String { "CreateRating" }

        func prepare(on database: any Database) async throws {
            try await database.schema("tour_ratings")
                .id()
                .field("tour_id", .uuid, .required, .references("tours", "id"))
                .field("name", .string, .required)
                .field("rating", .uint8, .required)
                .create()
        }

        func revert(on database: any Database) async throws {
            try await database.schema("tour_ratings").delete()
        }
    }
}
