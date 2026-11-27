import NIOSSL
import Fluent
import FluentMySQLDriver
import FluentSQLiteDriver
import Vapor
import JWT

func configure(_ app: Application) async throws {
    if app.environment == .testing {
        app.databases.use(.sqlite(.memory), as: .sqlite)
    } else {
        app.databases.use(DatabaseConfigurationFactory.mysql(
            hostname: Environment.get("DATABASE_HOST") ?? "localhost",
            port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? MySQLConfiguration.ianaPortNumber,
            username: Environment.get("DATABASE_USERNAME") ?? "root",
            password: Environment.get("DATABASE_PASSWORD") ?? "password",
            database: Environment.get("DATABASE_NAME") ?? "openfit",
            tlsConfiguration: nil
        ), as: .mysql)
    }

    app.asyncCommands.use(SeedCommand(), as: "seed")

    let jwtSecret: String
    if app.environment == .testing {
        jwtSecret = "secret-de-test-uniquement"
    } else {
        guard let secret = Environment.get("JWT_SECRET"), !secret.isEmpty else {
            fatalError("JWT_SECRET missing in .env")
        }
        jwtSecret = secret
    }
    app.jwt.signers.use(.hs256(key: jwtSecret))

    let corsConfiguration = CORSMiddleware.Configuration(
        allowedOrigin: .all,
        allowedMethods: [.GET, .POST, .PUT, .PATCH, .DELETE, .OPTIONS],
        allowedHeaders: [.accept, .authorization, .contentType],
        cacheExpiration: 800
    )
    app.middleware.use(CORSMiddleware(configuration: corsConfiguration), at: .beginning)

    app.migrations.add(CreateUser())
    app.migrations.add(CreateProfile())
    app.migrations.add(CreateDietaryPreference())
    app.migrations.add(CreateUserDietaryPreference())
    app.migrations.add(CreateWeightEntry())
    app.migrations.add(CreateActivityCategory())
    app.migrations.add(CreateActivityType())
    app.migrations.add(CreateActivity())
    app.migrations.add(CreateFoodCategory())
    app.migrations.add(CreateFood())
    app.migrations.add(CreateMeal())
    app.migrations.add(CreateMealItem())
    app.migrations.add(CreateGoal())

    try routes(app)
}
