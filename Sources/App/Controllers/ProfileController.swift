//
//  ProfileController.swift
//  App
//
//  Created by J. Charles N. M. on 22/09/2018.
//

import Foundation
import Crypto
import Vapor
import FluentSQLite
import Authentication
import CoreFoundation


/// - MARK - CREATE AND AUTHENTICATE USERS
public final class ProfileController {
    private func checkLoginRelated(_ req: Request, _ specifedUser: User) throws -> User {
        let user = try req.requireAuthenticated(User.self)
        guard try specifedUser.requireID() == user.requireID() else {
            throw Abort(HTTPResponseStatus.forbidden)
        }
        return user
    }
    
    
    /// Logs a user in, returning a token for accessing protected endpoints.
    public func create(_ req: Request) throws -> Future<Echo.Response> {
        throw Abort(HTTPResponseStatus.notImplemented)
    }
    
    /// Creates a new user.
    public func create(_ req: Request) throws -> Future<User.Response> {
        // decode request content
        throw Abort(HTTPResponseStatus.notImplemented)
    }
    
}

/// - MARK - USER UPDATE CONTROLLER

extension ProfileController {
    /// Update an user using User.Request.Update
    public func update(_ req: Request) throws -> Future<User.Response> {
        
        // decode request parameter (todos/:id)
        return try req.parameters.next(User.self).flatMap { uToUpdate -> Future<User.Response> in
            // fetch auth'd user
            let _ = try self.checkLoginRelated(req, uToUpdate)
            
            throw Abort(HTTPResponseStatus.notImplemented)
        }
    }
    
    /// Create User Profile Picture
    public func updateProfilePicture(_ req: Vapor.Request) throws -> Future<String> {
        throw Abort(HTTPResponseStatus.notImplemented)
        
    }
    
    /// Add User's Position
    public func addUserPosition(_ req: Vapor.Request) throws -> Future<Position.Response> {
        throw Abort(HTTPResponseStatus.notImplemented)
        
    }
    
    public func updateUserPosition(_ req: Vapor.Request) throws -> Future<Position.Response> {
        throw Abort(HTTPResponseStatus.notImplemented)
    }
    // /u/:uid/pos/:posid
    public func deleteUserPosition(_ req: Vapor.Request) throws -> Future<Position.Response> {
        throw Abort(HTTPResponseStatus.notImplemented)
    }
    
}

/// - MARK - GET USER INFOS
extension ProfileController {
    /*
     No more :
     [sqlite] [2018-09-22 09:41:46 +0000] SELECT * FROM "user" []
     [sqlite] [2018-09-22 09:41:46 +0000] SELECT * FROM "Profile" WHERE "Profile"."id" = (?) LIMIT 1 OFFSET 0 [1]
     [sqlite] [2018-09-22 09:41:46 +0000] SELECT * FROM "Profile" WHERE "Profile"."id" = (?) LIMIT 1 OFFSET 0 [2]
     **/
    /// List all users.
    public func list(_ req: Request) throws -> Future<[User.Response]> {
        throw Abort(HTTPResponseStatus.notImplemented)
    }
    
    /// Show an user.
    public func show(_ req: Request) throws -> Future<User.Response> {
        throw Abort(HTTPResponseStatus.notImplemented)
    }
    
    
    /// List User's Position
    public func userPositions(_ req: Vapor.Request) throws -> Future<[Position.Response]> {
        throw Abort(HTTPResponseStatus.notImplemented)
    }
    
}
