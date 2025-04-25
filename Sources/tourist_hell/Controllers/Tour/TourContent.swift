//
//  CreateTour.swift
//  tourist_hell
//
//  Created by Ruslan on 23.04.2025.
//

import Vapor

struct CreateTour: Content, @unchecked Sendable {
    var name: String
    var description: String

    @DateValue<ISO8601Strategy> var closestTourDate: Date
    var destinationCountry: String
    var banner: File
}

func tourValidations(_ validator: inout Validations, forPatch: Bool = false) {
    let fiveMegabytes = 5 * 8 * 1024 * 1024
    // TODO: Add unique check
    validator.add("name", as: String.self, is: .count(5...25) && .ascii, required: !forPatch)
    validator.add("description", as: String.self, is: .count(10...100), required: !forPatch)
    validator.add(
        "banner",
        as: File.self,
        // TODO: Validate proper mimetype (with signatures)
        is: .custom("Validates the file") { file in
            ["image/jpeg", "image/png"].contains(file.multipart?.contentType ?? "")
        },
        required: !forPatch,
        customFailureDescription: "Banner must be a valid image file (JPEG or PNG) less than 5MB.",
    )
}

extension CreateTour: Validatable {
    public static func validations(_ validator: inout Validations) {
        tourValidations(&validator)
    }
}

struct PatchTour: Content, @unchecked Sendable {
    var name: String?
    var description: String?

    @OptionalDateValue<ISO8601Strategy> var closestTourDate: Date?

    var destinationCountry: String?
    var banner: File?
}

extension PatchTour: Validatable {
    public static func validations(_ validator: inout Validations) {
        tourValidations(&validator, forPatch: true)
    }
}

enum TourSortBy: String, Codable {
    case country, date, name
}

struct IndexTourQuery: Content {
    var country: String?
    var sortBy: TourSortBy?
    var sortOrder: SortOrder?
    var search: String?
}
