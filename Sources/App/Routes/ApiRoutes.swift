import Vapor

struct ApiRoutes: RouteCollection {
    
    func boot(router: Router) throws {
        
        let userController = UserController()
        router.post("createUser", use: userController.createUser)
        router.get("loginUser", use: userController.loginUser)
        
        
        let tokenAuthenticationMiddleware = User.tokenAuthMiddleware() // 1
        let authedRoutes = router.grouped(tokenAuthenticationMiddleware) // 2
        authedRoutes.get("this/protected/route") { request -> Future<User.PublicUser> in
            let user = try request.requireAuthenticated(User.self) // 3
            return try user.authTokens.query(on: request).first().map(to: User.PublicUser.self) { userTokenType in // 4
                guard let tokenType = userTokenType?.token else { throw Abort.init(HTTPResponseStatus.notFound) }
                return User.PublicUser(username: user.username, token: tokenType) // 5
            }
        }
        
//
        let apiRouter = router.grouped("/api")
//        let token = User.tokenAuthMiddleware()

        //Public routes
        let publicRouter = apiRouter.grouped("/journal")
        publicRouter.get("", use: getAll)
        
        //Admin routes
        let adminRouter = apiRouter.grouped("/admin")
        // Create a route closure wrapped by this middleware
  
        adminRouter.get(Int.parameter, use: getEntry)
        adminRouter.post(use: newEntry)
        adminRouter.put(Int.parameter, use: editEntry)
        adminRouter.delete(Int.parameter, use: deleteEntry)
        
    }

    
    func getAll(_ req: Request) throws -> Future<[JournalEntry]> {
        return JournalEntry.query(on: req).all()
        }
    
    
    
    func getEntry(_ req: Request) throws -> Future<JournalEntry> {
        return try req.parameters.next(JournalEntry.self)
    }
    
    
    func newEntry(_ req: Request) throws -> Future<JournalEntry> {
//        print(req)
        return try req.content.decode(JournalEntry.self).flatMap(to: JournalEntry.self) { entry in

            return entry.save(on: req)
        }
    }
    
    func editEntry (_ req: Request) throws -> Future<JournalEntry> {
        let id = try req.parameters.next(Int.self)

        return try req.content.decode(JournalEntry.self).flatMap { updated in
            return JournalEntry.find(id, on: req).flatMap(to: JournalEntry.self) { original in
                guard let original = original
                    else {
                        throw Abort(.notFound)
                }
                original.title = updated.title
                original.content = updated.content
                return original.save(on: req)
            }
        }
        
    }
    
    func deleteEntry(_ req: Request) throws -> Future<HTTPStatus> {
        let id = try req.parameters.next(Int.self)
        
        return JournalEntry.find(id, on: req).flatMap { (entry)  in
            guard let entry = entry else{
                throw Abort(.notFound)
            }
            return entry.delete(on: req).transform(to: HTTPStatus.noContent)
        }
    }
        
}


