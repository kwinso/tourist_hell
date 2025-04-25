//
//  AuthController.swift
//  tourist_hell
//
//  Created by Ruslan on 22.04.2025.
//

import Fluent
import Foundation
import Vapor

struct BookingController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let bookings = routes.grouped("bookings")
        let adminRoutes = bookings.grouped(AdminToken.authenticator())

        adminRoutes.get(use: index)
    }

    @Sendable
    func index(req: Request) async throws -> [BookingDTO] {
        let q = try req.query.decode(BookingQuery.self)
        let bookingsQuery =
            Booking
            .query(on: req.db)
            .with(\.$tour)
            .with(\.$client)

        if let client = q.client {
            bookingsQuery.filter(\.$client.$id == client)
        }
        if let tour = q.tour {
            bookingsQuery.filter(\.$tour.$id == tour)
        }
        if let status = q.status {
            bookingsQuery.filter(\.$status == status)
        }

        return try await bookingsQuery.all().map { $0.toDTO() }
    }
}
