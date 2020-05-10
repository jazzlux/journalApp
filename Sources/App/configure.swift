//import Leaf
import Vapor
import FluentMySQL

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    // Register providers first
//    try services.register(LeafProvider())
    try services.register(FluentMySQLProvider())
    
    
    // Register routes to the router
     let router = EngineRouter.default()
     try routes(router)
     services.register(router, as: Router.self)
    
 
    // Register the configured MySQL database to the database config.
    let databaseConfig = MySQLDatabaseConfig(
        hostname: Environment.get("DB_HOSTNAME")!,
        port: 3316,
        username: Environment.get("DB_USER")!,
        password: Environment.get("DB_PASSWORD")!,
        database: Environment.get("DB_DATABASE")!
        
    )
    var databases = DatabasesConfig()
    let database = MySQLDatabase(config: databaseConfig)
    
    databases.add(database: database, as: .mysql)
    services.register(databases)

 
    
    var migrations = MigrationConfig()
    migrations.add(model: JournalEntry.self, database: .mysql)
    services.register(migrations)
    
    
    // Use Leaf for rendering views
//    config.prefer(LeafRenderer.self, for: ViewRenderer.self)

    // Register middleware
    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
    middlewares.use(FileMiddleware.self) // Serves files from `Public/` directory
    middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
    services.register(middlewares)
}


