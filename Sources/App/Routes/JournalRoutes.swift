import Vapor

struct  JournalRoutes: RouteCollection {
    
    let journal = JournalController()
    
    func boot(router: Router) throws {
        let topRouter = router.grouped("/journal")
        topRouter.get(use: getTotal)
        topRouter.post(use: newEntry)
        
        let entryRouter = router.grouped("/journal", Int.parameter)
        entryRouter.get(use: getEntry)
        entryRouter.post(use: editEntry)
        entryRouter.delete(use: removeEntry)
    }

    func getTotal(_ req: Request) -> String {
        let total = journal.total()
        print("total records: \(total)")
        return "\(total)"
    }
    
    func newEntry(_ req: Request) throws -> Future<HTTPStatus> {
        
        let newID = UUID().uuidString
        
        return try req.content.decode(Entry.self).map(to: HTTPStatus.self, { entry  in
            let newEntry = Entry(id: newID, title: entry.title, content: entry.content)
            guard let result = self.journal.create(newEntry)
                else {
                    throw Abort(.badRequest)
                    
            }

            print("created: \(result)")
            return .ok
        })
        
    }
    
    func getEntry(_ req: Request) throws -> Entry {
        let entryID = try req.parameters.next(Int.self)
        let response = req.response()
        
        guard let readContent = journal.read(index: entryID) else {
            throw Abort(.badRequest)
        }
        
        print("Read: \(readContent)")
        try response.content.encode(readContent, as: .formData)
        return readContent
        
    }
    
    func editEntry(_ req: Request) throws -> Future<HTTPStatus> {
        let index = try req.parameters.next(Int.self)
        let newID = UUID().uuidString
        return try req.content.decode(Entry.self).map(to: HTTPStatus.self, { (entry) in
            let newEntry = Entry(id: newID, title: entry.title, content: entry.content)
            guard let result = self.journal.update(index: index, entry: newEntry) else {
                throw Abort(.badRequest)
            }
            print("Updated: \(result)")
            return .ok
            
        })
        
    }
    
    func removeEntry(_ req: Request) throws -> HTTPStatus {
        let index = try req.parameters.next(Int.self)
        guard let deleted = journal.delete(index: index) else {
            throw Abort(.badRequest)
        }
        print("item deleted \(deleted)")
        return .ok
        
    }
    
    
}
