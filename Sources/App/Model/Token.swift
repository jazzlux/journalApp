import Foundation
import Vapor
import FluentMySQL
import Authentication

final class Token: MySQLModel {
    var id: Int?
    
    var token: String
    var userId: User.ID
    
    init(token: String, userId: User.ID) {
        self.token = token
        self.userId = userId
        
        
    }
}
extension Token {
    var user: Parent<Token, User> {
        return parent(\.userId)
    }
}


extension Token: BearerAuthenticatable {
    static var tokenKey: WritableKeyPath<Token, String> {
        return \Token.token
    }

}

extension Token: Authentication.Token {
    static var userIDKey: WritableKeyPath<Token, User.ID>{
        return \Token.userId
    }
    
    typealias UserType = User
    typealias UserIDType = User.ID
    
    
}

extension Token {
    
    static func createToken(forUser user: User) throws -> Token {
        let tokenString = Helpers.randomToken(withLength: 60)
        let newToken = try Token(token: tokenString, userId: user.requireID())
        return newToken
    }
}

extension Token: Migration{}
extension Token: Content{}

