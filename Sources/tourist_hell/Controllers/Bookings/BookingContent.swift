//
//  BookingContent.swift
//  tourist_hell
//
//  Created by Ruslan on 25.04.2025.
//

import Fluent
import Foundation
import Vapor

struct CreateBooking: Content, @unchecked Sendable {
    var tour: UUID
    var clientName: String
    var clientPhone: String
    @DateValue<ISO8601Strategy> var tourDate: Date
    var age: Int
}

extension CreateBooking: Validatable {
    public static func validations(_ validations: inout Validations) {
        validations.add("tour", as: UUID.self)

        validations.add(
            "age", as: Int.self, is: .range(18...65),
            customFailureDescription: "You should be at least 18 years old but no more than 65"
        )

        // tourdate sohuld be in future
        validations.add(
            "tourDate", as: Date.self,
            is: .custom("Date is at least tomorrow") { tourDate in
                // compare without time
                let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
                // tomorrow beginning
                let tomorrowStart = Calendar.current.date(
                    bySettingHour: 0, minute: 0, second: 0, of: tomorrow)!
                return tourDate >= tomorrowStart
            },
            customFailureDescription: "Tour date should be at least tomorrow"
        )
    }
}

struct BookingQuery: Content {
    var client: UUID?
    var tour: UUID?
    var status: BookingStatus?
    var dateSort: SortOrder?
}
