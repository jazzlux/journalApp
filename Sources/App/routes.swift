import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    
    let journalRoutes = JournalRoutes()
    try router.register(collection: journalRoutes)
    
    
    // "It works" page
    router.get { req in
        return try req.view().render("welcome")
    }
    
    // Says hello
    router.get("hello", String.parameter) { req -> Future<View> in
        return try req.view().render("hello", [
            "name": req.parameters.next(String.self)
        ])
    }
    
    router.post("new") { (req) -> Future<HTTPStatus> in
        return try req.content.decode(Entry.self).map {entry in
            print("appended a new entry: \(entry)")
            return HTTPStatus.accepted
        }
    }
    
    router.get("get") { (req) -> Entry in
        return Entry(id: "999", title: "First day", content: "Lots of fun")
    }

    
   
    
}
