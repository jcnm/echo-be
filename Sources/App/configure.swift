import Authentication
import FluentSQLite
import Vapor

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    // Register providers first
    try services.register(FluentSQLiteProvider())
    try services.register(AuthenticationProvider())

    // Register routes to the router
    let router = EngineRouter.default()
    if #available(OSX 10.12, *) {
        try routes(router)
    } else {
        // Fallback on earlier versions
    }
    services.register(router, as: Router.self)

    // Register middleware
    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
    // middlewares.use(SessionsMiddleware.self) // Enables sessions.
    // middlewares.use(FileMiddleware.self) // Serves files from `Public/` directory
    middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
    services.register(middlewares)

    // Configure a SQLite database
    let sqlite = try SQLiteDatabase(storage: .file(path: "/Users/jcnm/Documents/dev/suu/echo/be/echo-data.sqlite"))

    // Register the configured SQLite database to the database config.
    var databases = DatabasesConfig()
    databases.enableLogging(on: .sqlite)
    databases.add(database: sqlite, as: .sqlite)
    services.register(databases)

    /// Configure migrations
    var migrations = MigrationConfig()
    migrations.add(model: UserToken.self, database: .sqlite)
    migrations.add(model: User.self, database: .sqlite)
    migrations.add(model: Profile.self, database: .sqlite)
    migrations.add(model: Place.self, database: .sqlite)
    migrations.add(model: Echo.self, database: .sqlite)
    migrations.add(model: Event.self, database: .sqlite)
    migrations.add(model: Media.self, database: .sqlite)
    migrations.add(model: Channel.self, database: .sqlite)
    migrations.add(model: Ripple.self, database: .sqlite)
    migrations.add(model: Witness.self, database: .sqlite)
    migrations.add(model: Relation.self, database: .sqlite)
    migrations.add(model: Position.self, database: .sqlite)
//    migrations.add(model: Monitor.self, database: .sqlite)
    services.register(migrations)

}
