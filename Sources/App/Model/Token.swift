import Vapor
import FluentMySQL

final class Token: MySQLModel {
    var id: Int?
    
    var token: String
    var userId: User.ID
    
    init(token: String, userId: User.ID) {
        self.token = token
        self.userId = userId
    }
}
//extension Token {
//    var user: Parent<<#Child: Model#>, <#Parent: Model#>> {
//        return parent(\.userId)
//    }
//}
