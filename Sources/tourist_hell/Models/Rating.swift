//
//  Booking.swift
//  tourist_hell
//
//  Created by Ruslan on 22.04.2025.
//

import Fluent
import Vapor

import struct Foundation.UUID

final class Rating: Model, @unchecked Sendable {
    static let schema = "tour_ratings"

    @ID(key: .id)
    var id: UUID?

    @Parent(key: "tour_id")
    var tour: Tour

    @Field(key: "name")
    var name: String

    @Field(key: "rating")
    var rating: UInt8

    init() {}

    init(id: UUID? = nil, tourId: UUID, name: String, rating: UInt8) {
        self.id = id
        self.$tour.id = tourId
        self.name = name
        self.rating = rating
    }

    func toDTO() -> RatingDTO {
        return RatingDTO(with: self)
    }
}

struct RatingDTO: Content {
    var id: UUID?
    var name: String
    var rating: UInt8
    var tourId: UUID

    init(with rating: Rating) {
        self.id = rating.id
        self.tourId = rating.$tour.id
        self.name = rating.name
        self.rating = rating.rating
    }
}
