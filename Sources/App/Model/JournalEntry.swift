import Vapor
import FluentMySQL

final class JournalEntry : MySQLModel {
    var id: Int?
    var title: String?
    var content: String?
    
    init(id : Int? = nil, title: String?, content: String?) {
        self.id = id
        self.title = title
        self.content = content
    }
    
    
}

extension JournalEntry: Migration {}
extension JournalEntry: Content {}
extension JournalEntry: Parameter{}
