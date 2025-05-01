//
//  TourController.swift
//  tourist_hell
//
//  Created by Ruslan on 22.04.2025.
//

import Fluent
import Foundation
import Vapor

struct TourController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let tour =
            routes
            .grouped("tours")

        tour.get(use: index)

        tour.group(":id", "ratings") { ratingsRoute in
            ratingsRoute.get(use: ratings)
            ratingsRoute.post(use: createRating)
        }

        let adminRoutes =
            tour
            .grouped(AdminToken.authenticator())
            .grouped(AdminToken.guardMiddleware())

        adminRoutes.on(.POST, body: .collect(maxSize: "5mb"), use: create)
        adminRoutes.on(.PATCH, ":id", body: .collect(maxSize: "5mb"), use: patch)
        adminRoutes.delete(":id", use: delete)

        // todo:
        //  - PATCH for updates
        //  - GET for viewing (public), both one and multipe
        //  - Booking (should automatically create a client if no email matches)
        //  -
    }

    @Sendable
    func index(req: Request) async throws -> [TourDTO] {
        // TODO: Make so that only those tours that are have future date appear
        let query = try req.query.decode(IndexTourQuery.self)
        let tourQuery = Tour.query(on: req.db)

        if let country = query.country {
            tourQuery.filter(\.$destinationCountry == country)
        }

        // Probably could've been better but idc
        if let sortBy = query.sortBy {
            let sortOrder = query.sortOrder ?? .asc
            switch sortBy {
            case .country:
                tourQuery.sort(\.$destinationCountry, sortOrder.toDirection())
            case .date:
                tourQuery.sort(\.$closestTourDate, sortOrder.toDirection())
            case .name:
                tourQuery.sort(\.$name, sortOrder.toDirection())
            }
        }

        if let search = query.search {
            tourQuery.group(.or) { group in
                group
                    .filter(\.$name ~~ search)
                    .filter(\.$destinationCountry ~~ search)
                    .filter(\.$description ~~ search)
            }
        }

        return try await tourQuery.all().map { tour in
            tour.toDTO()
        }
    }
    @Sendable
    func create(req: Request) async throws -> TourDTO {
        try CreateTour.validate(content: req)
        let data = try req.content.decode(CreateTour.self)

        let tour = Tour(
            name: data.name,
            description: data.description,
            bannerPhoto: "test/italy.jpg",
            destinationCountry: data.destinationCountry,
            closestTourDate: Calendar.current.startOfDay(for: data.closestTourDate),
        )
        do {
            try await tour.save(on: req.db)
        } catch {
            // TODO: Remove the file
        }

        return tour.toDTO()
    }

    @Sendable
    func patch(req: Request) async throws -> TourDTO {
        try PatchTour.validate(content: req)
        guard let id = req.parameters.get("id", as: UUID.self) else {
            throw Abort(.badRequest)
        }
        let data = try req.content.decode(PatchTour.self)

        guard let tour = try await Tour.find(id, on: req.db) else {
            throw Abort(.notFound)
        }

        if let name = data.name {
            tour.name = name
        }
        if let description = data.description {
            tour.description = description
        }
        // if let banner = data.banner {
        //     // TODO: Remove old file and upload new one
        // }
        if let closestTourDate = data.closestTourDate {
            tour.closestTourDate = closestTourDate
        }
        if let country = data.destinationCountry {
            tour.destinationCountry = country
        }

        try await tour.save(on: req.db)
        return tour.toDTO()
    }

    @Sendable
    func delete(req: Request) async throws -> Bool {
        guard let id = req.parameters.get("id", as: UUID.self) else {
            throw Abort(.badRequest)
        }
        try await Tour.query(on: req.db).filter(\.$id == id).delete()

        return true
    }

    @Sendable
    func ratings(req: Request) async throws -> [RatingDTO] {
        guard let tourId = req.parameters.get("id", as: UUID.self) else {
            throw Abort(.badRequest)
        }
        let ratings = try await Rating.query(on: req.db).filter(\.$tour.$id == tourId).all()
        return ratings.map { rating in
            rating.toDTO()
        }
    }

    @Sendable
    func createRating(req: Request) async throws -> RatingDTO {
        try CreateRating.validate(content: req)
        let data = try req.content.decode(CreateRating.self)

        guard let tourId = req.parameters.get("id", as: UUID.self) else {
            throw Abort(.badRequest)
        }

        let rating = Rating(
            tourId: tourId,
            name: data.name,
            rating: data.rating
        )
        try await rating.save(on: req.db)

        return rating.toDTO()
    }
}
