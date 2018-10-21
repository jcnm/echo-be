import Crypto
import Vapor
import FluentSQLite
import Authentication
import CoreFoundation

/// - MARK - CREATE AND AUTHENTICATE USERS
final class UserController {
 
    public static func checkLoginRelated(_ req: Request, _ specifedUser: User) throws -> User {
        let user = try req.requireAuthenticated(User.self)
        guard try specifedUser.requireID() == user.requireID() else {
            throw Abort(HTTPResponseStatus.forbidden)
        }
        return user
    }
   /// Creates new users and authenticate them.
    /// Logs a user in, returning a token for accessing protected endpoints.
    func login(_ req: Request) throws -> Future<UserToken> {
        print("DEBUG INFO ------\n", req.debugDescription)
        print("DESCRIPTION INFO ------\n", req.description)
        print("CONTENT INFO ------\n", req.content)
        print("HTTP INFO ------\n", req.http)
        print("Parameter INFO ------\n", req.parameters)
        print("Query INFO ------\n", req.query)
        print("environment INFO ------\n", req.environment)
        print("config INFO ------\n", req.config)
        print("eventLoop INFO ------\n", req.eventLoop)
        print("END OF DEBUG INFO ###########")
       // get user auth'd by basic auth middleware
        let user = try req.requireAuthenticated(User.self)
        // create new token for this user
        let token = try UserToken.create(userID: user.requireID())
        
        // save and return token
        return token.save(on: req)
    }
    
    /// Creates a new user.
    func create(_ req: Request) throws -> Future<User.Response> {
        // decode request content
        return try req.content.decode(User.Request.Create.self).flatMap { user -> Future<User> in
            // verify that passwords match
            guard user.password == user.verifyPassword else {
                throw Abort(.badRequest, reason: "Password and verification must match.")
            }
            print(user)
            // hash user's password using BCrypt
            let hash = try BCrypt.hash(user.password)
            
            let pro = Profile(id: nil, attachedTo: nil, namePrefix: nil, givenName: user.givenName , middleName: nil, familyName: user.familyName, nameSuffix: nil, birthday: nil, backupEmail: nil, places: nil, emails: [ NamedEmail(name: "Main", value: user.email) ], uris: nil)
                
            return pro.create(on: req).flatMap({ (prof) in
                    return User(id: nil, passwordHash: hash, createdAt: Date(), updatedAt: Date(), acl: ACL(), login: user.login, screenName: user.login, shortName: nil, avatar: nil, kind: 2, signupChannel: nil, email: user.email, lastLocation: nil, profile: prof.id! , lastLogin: nil).create(on: req)
                })
            }.flatMap({ (user) in
                return user.response(req)
            })
        
    }
    
}

/// - MARK - USER UPDATE CONTROLLER

extension UserController {
    /// Update an user using User.Request.Update
    func update(_ req: Request) throws -> Future<User.Response> {
        // fetch auth'd user
        let user = try req.requireAuthenticated(User.self)
        
        // decode request parameter (todos/:id)
        return try req.parameters.next(User.self).flatMap { uToUpdate -> Future<User.Response> in
            guard try uToUpdate.requireID() == user.requireID() else {
                throw Abort(HTTPResponseStatus.forbidden)
            }
            
            return try req.content.decode(User.Request.Update.self).flatMap({ (uRequest) -> EventLoopFuture<User.Response> in
                guard try uRequest.id == uToUpdate.requireID() else {
                    throw Abort(HTTPResponseStatus.forbidden)
                }
                uToUpdate.screenName = uRequest.screenName
                // ...ALTER TABLE user ADD avatar TEXT;
                if let img = uRequest.avatar {
                    try self.savePicture(img, uToUpdate)
                    return uToUpdate.save(on: req).flatMap({ $0.response(req) })
                }
                return uToUpdate.save(on: req).flatMap({ $0.response(req) })
                
            })
        }
        
    }
    private func savePicture(_ img: File, _ user: User) throws {
        let home:URL = URL(fileURLWithPath: "~/suu/echo/be/images/", isDirectory: true)
        let kPath =  user.login + "/pp"
        var path = home.appendingPathComponent(kPath)
        path.appendPathComponent(img.filename.hash.description + "." + (img.ext ?? ".png"), isDirectory: false)
        try FileManager.default.createDirectory(at: path.deletingLastPathComponent(), withIntermediateDirectories: true, attributes: nil)
        try img.data.write(to: path) // save picture on disk
        user.avatar = path.absoluteString // save picture on user
    }
    
    /// Create User Profile Picture
    public func updateProfilePicture(_ req: Vapor.Request) throws -> Future<String> {
        // fetch auth'd user
        let userAuth = try req.requireAuthenticated(User.self)
        print(req.debugDescription)
        return try req.parameters.next(User.self).flatMap{ uToUpdate -> Future<String> in
            guard try uToUpdate.requireID() == userAuth.requireID() else {
                throw Abort(HTTPResponseStatus.forbidden)
            }
            return try req.content.decode(User.Request.Update.self).flatMap{ (uRequest) in
                guard try uRequest.id == uToUpdate.requireID() else {
                    throw Abort(HTTPResponseStatus.forbidden)
                }
                if let img = uRequest.avatar {
                    try self.savePicture(img, uToUpdate)
                    return uToUpdate.save(on: req).map({ $0.avatar! })
                } else {
                    throw Abort(HTTPResponseStatus.notAcceptable)
                }
            }
        }
        
    }
    
    /// Add User's Position
    public func addUserPosition(_ req: Vapor.Request) throws -> Future<Position.Response> {
        print("@@@@@@@@@@@@@@@@@@@@DEBUG INFO ------\n", req.debugDescription)
        print("@@@@@@@@@@@@@@@@@@@@CONTENT INFO ------\n", req.content)
        // fetch auth'd user
        let userAuth = try req.requireAuthenticated(User.self)
        return try req.parameters.next(User.self).flatMap{ uToUpdate -> Future<Position.Response> in
            guard try uToUpdate.requireID() == userAuth.requireID() else {
                throw Abort(HTTPResponseStatus.forbidden)
            }
            return try req.content.decode(Position.Request.Create.self).flatMap{ (posRequest) in
                print("@@@@@@@@@@@@@@@@@@@@POSITION REQUEST INFO ------\n", posRequest)
                guard try posRequest.attachedUser == uToUpdate.requireID() else {
                    throw Abort(HTTPResponseStatus.forbidden)
                }
                uToUpdate.lastLocation = posRequest.location
                return uToUpdate.save(on: req).flatMap{ uUpdated -> Future<Position.Response> in
                    let prc = Position(id: nil, attachedUser: posRequest.attachedUser, location: posRequest.location, createdAt: Date(), deleteDate: nil)
                    return prc.save(on: req).map{ pos in
                        return pos.response(req)
                    }
                }
            }
        }
        
    }

    public func updateUserPosition(_ req: Vapor.Request) throws -> Future<Position.Response> {
        throw Abort(HTTPResponseStatus.notImplemented)
    }
    // /u/:uid/pos/:posid
    public func deleteUserPosition(_ req: Vapor.Request) throws -> Future<Position.Response> {
        // fetch auth'd user
        let userAuth = try req.requireAuthenticated(User.self)
        return try req.parameters.next(User.self).flatMap{ uLookup -> Future<Position.Response> in
            let uId = try uLookup.requireID()
            guard try uId == userAuth.requireID() else {
                throw Abort(HTTPResponseStatus.forbidden)
            }
            return try req.parameters.next(Position.self).flatMap{ posToUpdate -> Future<Position.Response> in
                guard try posToUpdate.requireID() == userAuth.requireID() else {
                    throw Abort(HTTPResponseStatus.forbidden)
                }
                posToUpdate.deleteDate = Date()
                return posToUpdate.save(on: req).map{ $0.response(req) }
            }
        }
    }

}

/// - MARK - GET USER INFOS
extension UserController {
    /*
     No more :
     [sqlite] [2018-09-22 09:41:46 +0000] SELECT * FROM "user" []
     [sqlite] [2018-09-22 09:41:46 +0000] SELECT * FROM "Profile" WHERE "Profile"."id" = (?) LIMIT 1 OFFSET 0 [1]
     [sqlite] [2018-09-22 09:41:46 +0000] SELECT * FROM "Profile" WHERE "Profile"."id" = (?) LIMIT 1 OFFSET 0 [2]
**/
    /// List all users.
    func list(_ req: Request) throws -> Future<[User.Response]> {
        print("@@@@@@@@@@@@@@@@@@@@DEBUG INFO ------\n", req.debugDescription)
        print("@@@@@@@@@@@@@@@@@@@@CONTENT INFO ------\n", req.content)
        print("@@@@@@@@@@@@@@@@@@@@HTTP INFO ------\n", req.http)
        print("@@@@@@@@@@@@@@@@@@@@Parameter INFO ------\n", req.parameters)
        print("@@@@@@@@@@@@@@@@@@@@Query INFO ------\n", req.query)
        print("@@@@@@@@@@@@@@@@@@@@environment INFO ------\n", req.environment)
        print("@@@@@@@@@@@@@@@@@@@@config INFO ------\n", req.config)
        print("@@@@@@@@@@@@@@@@@@@@eventLoop INFO ------\n", req.eventLoop)
        print("@@@@@@@@@@@@@@@@@@@@END OF DEBUG INFO ###########")// fetch auth'd user
        print("@@@@@@@@@@@@@@@@@@@@Parameter VALUE INFO ------\n", req.parameters.values)
        let user = try req.requireAuthenticated(User.self)
        guard user.id != nil else {
            throw Abort(HTTPResponseStatus.unauthorized)
        }
        let users = User.query(on: req).join(\Profile.id, to: \User.id).alsoDecode(Profile.self).all()
        return users.flatMap({(uar) -> EventLoopFuture<[User.Response]> in
            let uresp = uar.compactMap({ (u) -> Future<User.Response> in
                return u.0.response(req, with: u.1)
            }).flatten(on: req)
            return uresp
        })
    }
    
    /// Show an user.
    func show(_ req: Request) throws -> Future<User.Response> {
        // fetch auth'd user
        let _ = try req.requireAuthenticated(User.self)
        
        // decode request parameter (todos/:id)
        return try req.parameters.next(User.self).flatMap { u -> Future<User.Response> in
            
            return u.response(req)
        }
        
    }
    
    
    /// List User's Position
    public func userPositions(_ req: Vapor.Request) throws -> Future<[Position.Response]> {
        print("@@@@@@@@@@@@@@@@@@@@DEBUG INFO ------\n", req.debugDescription)
        print("@@@@@@@@@@@@@@@@@@@@CONTENT INFO ------\n", req.content)
        // fetch auth'd user
        let userAuth = try req.requireAuthenticated(User.self)
        return try req.parameters.next(User.self).flatMap{ uLookup -> Future<[Position.Response]> in
            let uId = try uLookup.requireID()
            guard try uId == userAuth.requireID() else {
                throw Abort(HTTPResponseStatus.forbidden)
            }
            let posQuery = Position.query(on: req)
                .filter(\.attachedUser, .equal, uId)
                .filter(\.deleteDate, SQLiteBinaryOperator.equal , nil)
            return posQuery.all().flatMap{
                return req.future($0.map{ $0.response(req) })
            }
        }
    }
    

}
