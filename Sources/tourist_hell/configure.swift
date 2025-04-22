import NIOSSL
import Fluent
import FluentPostgresDriver
import Vapor
import Foundation
import JWT

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
 
    
    
    guard let secret = Environment.get("APP_SECRET") else {
        fatalError("APP_SECRET environment variable must be set.")
    }
    let hmacKey = HMACKey(from: secret)
    await app.jwt.keys.add(hmac: hmacKey, digestAlgorithm: .sha256)
    app.databases.use(DatabaseConfigurationFactory.postgres(configuration: .init(
        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
        port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? SQLPostgresConfiguration.ianaPortNumber,
        username: Environment.get("DATABASE_USERNAME") ?? "vapor_username",
        password: Environment.get("DATABASE_PASSWORD") ?? "vapor_password",
        database: Environment.get("DATABASE_NAME") ?? "vapor_database",
        tls: .prefer(try .init(configuration: .clientDefault)))
    ), as: .psql)

    app.migrations.add(Admin.CreateAdmin())
    app.migrations.add(Admin.SeedAdmins())

    // register routes
    try routes(app)
}
