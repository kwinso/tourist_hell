//
//  SeedTours.swift
//  tourist_hell
//
//  Created by Ruslan on 24.04.2025.
//

import Fluent
import Foundation
import Vapor
import FluentSQL

extension Tour {
    struct SeedTours: AsyncMigration {
        var name: String { "SeedTours" }
        
        func prepare(on database: any Database) async throws {
            let tours = [
                Tour(
                    name: "Brazil madness",
                    description: "Take yourself on a journey with hot Brazillian men and see the real Brazil by yourself.",
                    bannerPhoto: "/test/brazil.jpg",
                    destinationCountry: "Brazil",
                    closestTourDate: Calendar.current.date(byAdding: .day, value: 1, to: Date())!
                ),
                Tour(
                    name: "Sakura Serenity",
                    description: "Experience the breathtaking beauty of Japan during cherry blossom season.",
                    bannerPhoto: "/test/japan.jpg",
                    destinationCountry: "Japan",
                    closestTourDate: Calendar.current.date(byAdding: .day, value: 15, to: Date())!
                ),
                Tour(
                    name: "Mystical Morocco",
                    description: "Explore the vibrant souks, majestic deserts, and ancient cities of Morocco.",
                    bannerPhoto: "/test/morocco.jpg",
                    destinationCountry: "Morocco",
                    closestTourDate: Calendar.current.date(byAdding: .day, value: 30, to: Date())!
                ),
                Tour(
                    name: "African Safari Adventure",
                    description: "Embark on an unforgettable wildlife safari through Kenya's stunning savannas.",
                    bannerPhoto: "/test/kenya.jpg",
                    destinationCountry: "Kenya",
                    closestTourDate: Calendar.current.date(byAdding: .day, value: 45, to: Date())!
                ),
                Tour(
                    name: "Italian Romance",
                    description: "Indulge in the art, history, and cuisine of Italy’s most romantic cities.",
                    bannerPhoto: "/test/italy.jpg",
                    destinationCountry: "Italy",
                    closestTourDate: Calendar.current.date(byAdding: .day, value: 60, to: Date())!
                ),
                Tour(
                    name: "Northern Lights Quest",
                    description: "Chase the mesmerizing auroras in the icy wilderness of Iceland.",
                    bannerPhoto: "/test/iceland.jpg",
                    destinationCountry: "Iceland",
                    closestTourDate: Calendar.current.date(byAdding: .day, value: 75, to: Date())!
                )
            ]
            
            try await tours.create(on: database)
        }
        
        func revert(on database: any Database) async throws {
            try await Tour.query(on: database).delete()
        }
    }
}
