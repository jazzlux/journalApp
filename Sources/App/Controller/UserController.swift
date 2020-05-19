import Vapor
import FluentMySQL
import Authentication

final class UserController{

    func createUser(_ request: Request) throws -> Future<User.PublicUser> { // 1
        return try request.content.decode(User.self).flatMap(to: User.PublicUser.self) { user in // 2
            let passwordHashed = try request.make(BCryptDigest.self).hash(user.password)
            let newUser = User(username: user.username, password: passwordHashed)
            return newUser.save(on: request).flatMap(to: User.PublicUser.self) { createdUser in
                let accessToken = try Token.createToken(forUser: createdUser)
                return accessToken.save(on: request).map(to: User.PublicUser.self) { createdToken in // 4
                    let publicUser = User.PublicUser(username: createdUser.username, token: createdToken.token)
                    return publicUser // 5
                }
            }
            
        }
    }
    
    
    
    
    //    func createUser(_ request: Request) throws -> Future<User> {
    //        return try request.content.decode(User.self).flatMap(to: User.self) { (user) -> Future<User> in
    //            let passwordHashed = try request.make(BCryptDigest.self).hash(user.password)
    //            let newUser = User(username: user.username, password: passwordHashed)
    //            return newUser.save(on: request)
    //        }
    //    }
    //
    func loginUser(_ request: Request) throws -> Future<User> {
        return try request.content.decode(User.self).flatMap(to: User.self) { user in // 1
            let passwordVerifier = try request.make(BCryptDigest.self) // 2
            return User.authenticate(username: user.username, password: user.password, using: passwordVerifier, on: request).unwrap(or: Abort.init(HTTPResponseStatus.unauthorized)) //
        }
        
    }
    
}

