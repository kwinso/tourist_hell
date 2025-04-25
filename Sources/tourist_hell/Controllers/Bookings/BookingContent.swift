//
//  BookingControllerj.swift
//  tourist_hell
//
//  Created by Ruslan on 25.04.2025.
//

import Vapor

struct BookingQuery: Content {
    var client: UUID?
    var tour: UUID?
    var status: BookingStatus?
}
