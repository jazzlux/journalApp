import Vapor
import FluentMySQL
import Authentication

final class UserController {
    func createUser(_ request: Request) throws -> Future<User> {
        return try request.content.decode(User.self).flatMap(to: User.self) { (user) -> Future<User> in
            let passwordHashed = try request.make(BCryptDigest.self).hash(user.password)
            let newUser = User(username: user.username, password: passwordHashed)
            return newUser.save(on: request)
        }
    }
    
    func loginUser(_ request: Request) throws -> Future<User> {
        return try request.content.decode(User.self).flatMap(to: User.self) { user in // 1
        let passwordVerifier = try request.make(BCryptDigest.self) // 2
        return User.authenticate(username: user.username, password: user.password, using: passwordVerifier, on: request).unwrap(or: Abort.init(HTTPResponseStatus.unauthorized)) // 
    }
    
}
}

