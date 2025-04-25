//
//  SeedBookings.swift
//  tourist_hell
//
//  Created by Ruslan on 25.04.2025.
//

import Fluent
import FluentSQL
import Vapor

extension Rating {
    struct SeedRatings: AsyncMigration {
        var name: String { "SeedRatings" }

        func prepare(on database: any Database) async throws {
            let tours = try await Tour.query(on: database).all()

            var ratings: [Rating] = []
            for tour in tours {
                let rating = Rating()
                rating.$tour.id = try tour.requireID()
                rating.name = ["Great", "Good", "Bad", "Ugly"].randomElement()!
                rating.rating = UInt8.random(in: 1...5)
                ratings.append(rating)
            }
            try await ratings.create(on: database)
        }

        func revert(on database: any Database) async throws {
            try await Rating.query(on: database).delete()
        }
    }
}
