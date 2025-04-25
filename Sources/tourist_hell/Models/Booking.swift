//
//  Booking.swift
//  tourist_hell
//
//  Created by Ruslan on 22.04.2025.
//

import Fluent
import Vapor

import struct Foundation.UUID

enum BookingStatus: String, Codable {
    case created, confirmed, paid
}

final class Booking: Model, @unchecked Sendable {
    static let schema = "bookings"

    @ID(key: .id)
    var id: UUID?

    @Parent(key: "tour_id")
    var tour: Tour

    @Parent(key: "client_id")
    var client: Client

    @Field(key: "tour_date")
    var tourDate: Date

    @Enum(key: "status")
    var status: BookingStatus

    init() {}

    init(id: UUID? = nil, tourId: UUID, clientId: UUID, tourDate: Date, status: BookingStatus) {
        self.id = id
        self.$tour.id = tourId
        self.$client.id = clientId
        self.tourDate = tourDate
        self.status = status
    }

    func toDTO() -> BookingDTO {
        return BookingDTO(with: self)
    }
    func toStatusDTO() -> BookingStatusDTO {
        return BookingStatusDTO(with: self)
    }
}

struct BookingDTO: Content {
    var id: UUID?
    var client: ClientDTO
    var tourDate: Date
    var status: BookingStatus
    var tour: TourDTO

    init(with booking: Booking) {
        self.id = booking.id
        self.client = ClientDTO(with: booking.client)
        self.tourDate = booking.tourDate
        self.status = booking.status
        self.tour = TourDTO(with: booking.tour)
    }
}

struct BookingStatusDTO: Content {
    var id: UUID?
    var status: BookingStatus

    init(with booking: Booking) {
        self.id = booking.id
        self.status = booking.status
    }
}
