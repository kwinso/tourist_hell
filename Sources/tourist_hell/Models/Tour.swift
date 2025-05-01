//
//  Tour.swift
//  tourist_hell
//
//  Created by Ruslan on 22.04.2025.
//
import Fluent
import Vapor

import struct Foundation.UUID

final class Tour: Model, @unchecked Sendable {
    static let schema = "tours"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "name")
    var name: String

    @Field(key: "description")
    var description: String

    @Field(key: "destination_country")
    var destinationCountry: String

    @Field(key: "closest_tour_date")
    var closestTourDate: Date

    /// Banner photo is a relative URL path to where the banner photo is stored
    // @Field(key: "banner_photo")
    // var bannerPhoto: String

    @Children(for: \.$tour)
    var bookings: [Booking]

    init() {}

    init(
        id: UUID? = nil, name: String, description: String, destinationCountry: String,
        closestTourDate: Date
    ) {
        self.id = id
        self.name = name
        self.description = description
        // self.bannerPhoto = bannerPhoto
        self.destinationCountry = destinationCountry
        self.closestTourDate = closestTourDate
    }

    func toDTO() -> TourDTO {
        return TourDTO(with: self)
    }
}

struct TourDTO: Content {
    var id: UUID?
    var name: String
    var description: String
    var closestTourDate: Date
    var destinationCountry: String

    init(with tour: Tour) {
        self.id = tour.id
        self.name = tour.name
        self.description = tour.description
        self.closestTourDate = tour.closestTourDate
        self.destinationCountry = tour.destinationCountry
    }
}
