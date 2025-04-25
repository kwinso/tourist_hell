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
        bookings.post(use: create)
        bookings.get("status", ":id", use: status)

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
            .sort(\.$tourDate, q.dateSort?.toDirection() ?? .ascending)

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

    func create(req: Request) async throws -> BookingStatusDTO {
        try CreateBooking.validate(content: req)
        let data = try req.content.decode(CreateBooking.self)
        guard let tour = try await Tour.find(data.tour, on: req.db) else {
            throw Abort(.notFound, reason: "Tour not found")
        }

        let client =
            try await Client.query(on: req.db).filter(\.$phoneNumber == data.clientPhone).first()
            ?? Client(name: data.clientName, phoneNumber: data.clientName, age: data.age)

        client.phoneNumber = data.clientPhone
        client.age = data.age
        client.name = data.clientName
        if client.id == nil {
            try await client.save(on: req.db)
        } else {
            try await client.update(on: req.db)
        }

        let booking = Booking(
            tourId: try tour.requireID(),
            clientId: try client.requireID(),
            tourDate: data.tourDate,
            status: .created
        )
        try await booking.save(on: req.db)

        return booking.toStatusDTO()
    }

    @Sendable
    func status(req: Request) async throws -> BookingStatusDTO {
        guard let id = req.parameters.get("id", as: UUID.self) else {
            throw Abort(.badRequest)
        }
        guard let booking = try await Booking.find(id, on: req.db) else {
            throw Abort(.notFound)
        }

        return booking.toStatusDTO()
    }
}
