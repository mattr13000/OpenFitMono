import Fluent
import Vapor

func routes(_ app: Application) throws {
    let api = app.grouped("api")

    api.get("health") { req async -> String in
        "OK"
    }

    try api.register(collection: AuthController())
}
