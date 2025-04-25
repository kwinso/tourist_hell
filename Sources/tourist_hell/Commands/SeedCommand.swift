//
//  SeedCommand.swift
//  tourist_hell
//
//  Created by Ruslan on 25.04.2025.
//

import Fluent
import Vapor

struct SeedCommand: AsyncCommand {
    struct Signature: CommandSignature {}

    var help = "Seed database with sample data. Removes previous data before seeding."

    func run(using context: CommandContext, signature: Signature) async throws {
        let database = context.application.db
        let seeders: [any AsyncMigration] = [
            Admin.SeedAdmins(),
            Tour.SeedTours(),
            Client.SeedClients(),
            Booking.SeedBookings(),
            Rating.SeedRatings(),
        ]

        context.application.logger.info("Running seeders revert to clear the database...")
        let revertSeeders = seeders.reversed()
        for seeder in revertSeeders {
            try await seeder.revert(on: database)
        }
        context.application.logger.info("Running seeders...")
        for seeder in seeders {
            context.application.logger.info("Running \(seeder.name)...")
            try await seeder.prepare(on: database)
        }
        context.application.logger.info("Seeding complete.")
    }

}
