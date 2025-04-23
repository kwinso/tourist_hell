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
    
    /// Banner photo is a relative URL path to where the banner photo is stored
    @Field(key: "banner_photo")
    var bannerPhoto: String
    
    init() {}
    
    init(id: UUID? = nil, name: String, description: String, bannerPhoto: String) {
        self.id = id
        self.name = name
        self.description = description
        self.bannerPhoto = bannerPhoto
    }
    
    func toDTO() -> TourDTO {
        return TourDTO(with: self)
    }
}

struct TourDTO: Content {
    var id: UUID?
    var name: String
    var description: String
    var bannerPhoto: String
    
    init(with tour: Tour) {
        self.id = tour.id
        self.name = tour.name
        self.description = tour.description
        self.bannerPhoto = tour.bannerPhoto
    }
}
