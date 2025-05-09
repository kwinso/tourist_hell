import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req async in
        "It works!"
    }
    
    try app.register(collection: AuthController())
    try app.register(collection: TourController())
    try app.register(collection: ClientController())
    try app.register(collection: BookingController())
}
