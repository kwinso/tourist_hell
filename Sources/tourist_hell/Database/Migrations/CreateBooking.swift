//
//  CreateAdmin.swift
//  tourist_hell
//
//  Created by Ruslan on 22.04.2025.
//

import Fluent
import FluentSQL
import Vapor

extension Booking {
    struct CreateBooking: AsyncMigration {
        var name: String { "CreateBooking" }

        func prepare(on database: any Database) async throws {
            // An example of reading an enum and using it to define a new field.
            try await database.transaction { database in
                let bookingStatus = try await database.enum("booking_status")
                    .case("created")
                    .case("confirmed")
                    .case("paid")
                    .create()

                try await database.schema("bookings")
                    .id()
                    .field(
                        "tour_id", .uuid, .required, .references("tours", "id", onDelete: .cascade)
                    )
                    .field(
                        "client_id", .uuid, .required,
                        .references("clients", "id", onDelete: .cascade)
                    )
                    .field("tour_date", .date, .required)
                    .field("status", bookingStatus, .required)
                    .unique(on: "client_id", "tour_id")
                    .create()
            }
        }

        func revert(on database: any Database) async throws {
            try await database.transaction { dabase in
                try await database.schema("bookings").delete()
                try await database.enum("booking_status").delete()
            }
        }
    }
}
