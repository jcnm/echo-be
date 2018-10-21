//
//  ChannelController.swift
//  App
//
//  Created by J. Charles N. M. on 24/09/2018.
//

import Foundation
import Vapor
import FluentSQLite
import Authentication
import Crypto
/// - MARK - CREATE AND AUTHENTICATE Channels
public final class ChannelController {
    
    public static let defaultFluctuation    = Fluctuation()
    
    private func checkLoginRelated(_ req: Request, _ specifedUser: User) throws -> User {
        let user = try req.requireAuthenticated(User.self)
        guard try specifedUser.requireID() == user.requireID() else {
            throw Abort(HTTPResponseStatus.forbidden)
        }
        return user
    }
    
    
    ///
    public func create(_ req: Request) throws -> Future<Channel.Response> {
        let user = try req.requireAuthenticated(User.self)
        return try req.content.decode(Channel.Request.Create.self).flatMap{ (cRequest) -> Future<Channel.Response> in
            guard try cRequest.owner == user.requireID() else {
                throw Abort(HTTPResponseStatus.forbidden)
            }
            let tokenClient = try CryptoRandom().generateData(count: 16).base64EncodedString()
            let tokenApi = try CryptoRandom().generateData(count: 8).base64EncodedString()
            let _ = try BCrypt.hash(tokenClient, salt: user.login)
            let now = Date()
            let actualAcl = ACL()
            let chan = Channel(id: nil, createdAt: now, updatedAt: now, acl: actualAcl, owner: cRequest.owner, title: cRequest.name, shortName: cRequest.shortName, kind: cRequest.kind, apiKey: tokenApi, clientSecret: tokenClient, uris: nil, emails: [NamedEmail(name: "main", value: cRequest.email)], places: nil)
                //Echo(id: nil, createdAt: now, updatedAt: now, acl: actualAcl, parent: nil, author: user.id!, attachedEvent: nil, location: eRequest.location, fluctuation: EchoController.defaultFluctuation, viewers: nil, device: eRequest.attachedState)
            return chan.save(on: req).flatMap{ savedChannel in
                return savedChannel.response(req)
                }
            }
    }
    
    ///
    public func add(_ req: Request) throws -> Future<Channel.Response> {
        // decode request content
        throw Abort(HTTPResponseStatus.notImplemented)
    }
    
}

/// - MARK - CHANNEL UPDATE

extension ChannelController {
    /// Update an user using User.Request.Update
    public func update(_ req: Request) throws -> Future<Channel.Response> {
        
        // decode request parameter (todos/:id)
        return try req.parameters.next(User.self).flatMap { uToUpdate -> Future<Channel.Response> in
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
extension ChannelController {
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
