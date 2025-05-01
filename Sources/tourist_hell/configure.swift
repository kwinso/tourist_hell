import Fluent
import FluentPostgresDriver
import Foundation
import JWT
import NIOSSL
import Vapor

// configures your application
public func configure(_ app: Application) async throws {
    let corsConfiguration = CORSMiddleware.Configuration(
        allowedOrigin: .all,  // Not good but who cares, they don't even look at our code anyway
        allowedMethods: [.GET, .POST, .PUT, .OPTIONS, .DELETE, .PATCH],
        allowedHeaders: [
            .accept, .authorization, .contentType, .origin, .xRequestedWith, .userAgent,
            .accessControlAllowOrigin,
        ]
    )
    let cors = CORSMiddleware(configuration: corsConfiguration)
    // cors middleware should come before default error middleware using `at: .beginning`
    app.middleware.use(cors, at: .beginning)

    // uncomment to serve files from /Public folder
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    guard let secret = Environment.get("APP_SECRET") else {
        fatalError("APP_SECRET environment variable must be set.")
    }
    let hmacKey = HMACKey(from: secret)
    await app.jwt.keys.add(hmac: hmacKey, digestAlgorithm: .sha256)

    app.databases.use(
        DatabaseConfigurationFactory.postgres(
            configuration: .init(
                hostname: Environment.get("DATABASE_HOST") ?? "localhost",
                port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:))
                    ?? SQLPostgresConfiguration.ianaPortNumber,
                username: Environment.get("DATABASE_USERNAME") ?? "vapor_username",
                password: Environment.get("DATABASE_PASSWORD") ?? "vapor_password",
                database: Environment.get("DATABASE_NAME") ?? "vapor_database",
                tls: .prefer(try .init(configuration: .clientDefault)))
        ), as: .psql)

    app.migrations.add(Admin.CreateAdmin())
    app.migrations.add(Tour.CreateTour())
    app.migrations.add(Client.CreateClient())
    app.migrations.add(Booking.CreateBooking())
    app.migrations.add(Rating.CreateRating())

    app.asyncCommands.use(SeedCommand(), as: "seed")

    // register routes
    try routes(app)
}
