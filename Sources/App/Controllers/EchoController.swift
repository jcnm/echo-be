//
//  EchoController.swift
//  App
//
//  Created by J. Charles N. M. on 22/09/2018.
//

import Foundation
import Crypto
import Vapor
import FluentSQLite
import Authentication

/// - MARK - CREATE AND AUTHENTICATE User Echos
public final class EchoController {
    
    public static let defaultFluctuation    = Fluctuation()
    
    private func checkLoginRelated(_ req: Request, _ specifedUser: User) throws -> User {
        let user = try req.requireAuthenticated(User.self)
        guard try specifedUser.requireID() == user.requireID() else {
            throw Abort(HTTPResponseStatus.forbidden)
        }
        return user
    }
    

    ///
    public func create(_ req: Request) throws -> Future<Echo.Response> {
        
        let user = try req.requireAuthenticated(User.self)
        return try req.content.decode(Echo.Request.Create.self).flatMap{ (eRequest) -> Future<Echo.Response> in
            guard try eRequest.author == user.requireID() else {
                throw Abort(HTTPResponseStatus.forbidden)
            }
            let now = Date()
            let actualAcl = ACL()
            let nEcho = Echo(id: nil, createdAt: now, updatedAt: now, acl: actualAcl, parent: nil, author: user.id!, attachedEvent: nil, location: eRequest.location, fluctuation: EchoController.defaultFluctuation, viewers: nil, device: eRequest.attachedState)
                return nEcho.save(on: req).flatMap{ savedEcho in
                    let echoMedia = Media(id: nil, owner: user.id!, createdAt: now, updatedAt: now, acl: actualAcl, attachedEcho: savedEcho.id!, lang: eRequest.lang , kind: MediaKind.text.rawValue, data: "", descr: eRequest.content)
                    return echoMedia.create(on: req).flatMap{ med in
                        EchoPostProcessing.newEchoProcessing(echo: savedEcho, from: req)
                        return try savedEcho.response(req, medias: [med])
                    }
                   
            }
        }
    }
    
    ///
    public func add(_ req: Request) throws -> Future<Echo.Response> {
        // decode request content
        throw Abort(HTTPResponseStatus.notImplemented)
    }
    
}

/// - MARK - ECHO UPDATE

extension EchoController {
    /// Update an user using User.Request.Update
    public func update(_ req: Request) throws -> Future<Echo.Response> {
        
        // decode request parameter (todos/:id)
        return try req.parameters.next(User.self).flatMap { uToUpdate -> Future<Echo.Response> in
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

/// - MARK - GET ECHO INFOS
extension EchoController {
    /*
     No more :
     [sqlite] [2018-09-22 09:41:46 +0000] SELECT * FROM "user" []
     [sqlite] [2018-09-22 09:41:46 +0000] SELECT * FROM "Profile" WHERE "Profile"."id" = (?) LIMIT 1 OFFSET 0 [1]
     [sqlite] [2018-09-22 09:41:46 +0000] SELECT * FROM "Profile" WHERE "Profile"."id" = (?) LIMIT 1 OFFSET 0 [2]
     **/
    /// List all users.
    public func list(_ req: Request) throws -> Future<[Echo.Response]> {
        throw Abort(HTTPResponseStatus.notImplemented)
    }
    
    /// Show an user.
    public func show(_ req: Request) throws -> Future<Echo.Response> {
        throw Abort(HTTPResponseStatus.notImplemented)
    }
    
    
    /// List User's Position
    public func userPositions(_ req: Vapor.Request) throws -> Future<[Position.Response]> {
        throw Abort(HTTPResponseStatus.notImplemented)
    }
  
}
