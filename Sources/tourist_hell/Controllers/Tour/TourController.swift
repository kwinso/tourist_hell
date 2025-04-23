//
//  TourController.swift
//  tourist_hell
//
//  Created by Ruslan on 22.04.2025.
//

import Vapor
import Foundation



struct TourController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let tour = routes.grouped("tours")
        
        tour.get(use: index)
        
        let adminRoutes = tour
            .grouped(AdminToken.authenticator())
            .grouped(AdminToken.guardMiddleware())
        
        adminRoutes.on(.POST, body: .collect(maxSize: "5mb"), use: create)
        // todo:
        //  - PATCH for updates
        //  - GET for viewing (public), both one and multipe
        //  - Booking (should automatically create a client if no email matches)
        //  -
    }
    
    @Sendable
    func index(req: Request) async throws -> [TourDTO] {
        let tours = try await Tour.query(on: req.db).all()
        return tours.map { tour in
            tour.toDTO()
        }
    }
    
    @Sendable
    func create(req: Request) async throws -> TourDTO {
        try CreateTour.validate(content: req)
        let data = try req.content.decode(CreateTour.self)
        
        let uploadFilename = uploadFilename(ext: data.banner.extension ?? "png")
        let uploadPath = "uploads/\(uploadFilename)"
        let absoluteUploadPath = req.application.directory.publicDirectory.appending(uploadPath)

        
        try await req.fileio.writeFile(data.banner.data, at: absoluteUploadPath)
        
        let tour = Tour(name: data.name, description: data.description, bannerPhoto: uploadPath)
        do {
            try await tour.save(on: req.db)
        } catch {
            // TODO: Remove the file
        }
            
        return tour.toDTO()
    }
}

extension TourController {
    fileprivate func saveTourBannerFile(name: String, data: Data) -> Bool {
        let path = FileManager.default
            .currentDirectoryPath.appending("/\(name)")
        return FileManager.default.createFile(atPath: path, contents: data, attributes: nil)
        
    }
}
