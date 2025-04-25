//
//  SeedBookings.swift
//  tourist_hell
//
//  Created by Ruslan on 25.04.2025.
//

import Fluent
import FluentSQL
import Vapor

extension Booking {
    struct SeedBookings: AsyncMigration {
        var name: String { "SeedBookings" }

        func prepare(on database: any Database) async throws {
            let tours = try await Tour.query(on: database).all()
            let clients = try await Client.query(on: database).all()

            var bookings: [Booking] = []
            for tour in tours {
                let client = clients.randomElement()!
                let b = Booking()
                b.$client.id = try client.requireID()
                b.$tour.id = try tour.requireID()
                b.status = [.created, .confirmed, .paid].randomElement()!
                b.tourDate = Calendar.current.date(
                    byAdding: .day, value: Int.random(in: 7...10), to: Date())!
                bookings.append(b)
            }
            try await bookings.create(on: database)
        }

        func revert(on database: any Database) async throws {
            try await Booking.query(on: database).delete()
        }
    }
}
