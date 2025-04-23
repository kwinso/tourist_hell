//
//  CreateTour.swift
//  tourist_hell
//
//  Created by Ruslan on 23.04.2025.
//

import Vapor

struct CreateTour: Content {
    var name: String
    var description: String
    var banner: File
}

extension CreateTour: Validatable {
    static let fiveMegabytes = 5 * 8 * 1024 * 1024
    
    public static func validations(_ validator: inout Validations) {
        // TODO: Add unique check
        validator.add("name", as: String.self, is: .count(5...25) && .ascii)
        validator.add("description", as: String.self, is: .count(10...100))
        validator.add(
            "banner",
            as: File.self,
            // TODO: Validate proper mimetype (with signatures)
            is: .custom("Validates the file") { file in
                ["image/jpeg", "image/png"].contains(file.multipart?.contentType ?? "") 
            },
            customFailureDescription: "Banner must be a valid image file (JPEG or PNG) less than 5MB."
        )
    }
}
