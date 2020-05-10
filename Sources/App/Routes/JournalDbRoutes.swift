import Vapor

struct JournalDbRoutes: RouteCollection {
    
    
    func boot(router: Router) throws {
        let topRouter = router.grouped("/api")
        topRouter.get(use: getAll)
        topRouter.post(use: newEntry)
        
    }
    
    
    
    func getAll(_ req: Request) throws -> Future<[JournalEntry]> {
        
        return JournalEntry.query(on: req).all()
        }
    
    
    func newEntry(_ req: Request) throws -> Future<JournalEntry> {
        return try req.content.decode(JournalEntry.self).flatMap(to: JournalEntry.self) { entry in
            return entry.save(on: req)
        }
        }
//        return try req.content.decode(JournalEntry.self).save(on: req)
        
    
    
}


