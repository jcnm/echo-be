//
//  PlaceController.swift
//  App
//
//  Created by J. Charles N. M. on 24/09/2018.
//

import Foundation
import Vapor
import FluentSQLite
import Authentication
import Crypto
/// - MARK - CREATE AND AUTHENTICATE Places
public final class PlaceController {
    
    ///
    public func create(_ req: Request) throws -> Future<Place.Response> {
        let user = try req.requireAuthenticated(User.self)
        return try req.content.decode(Place.Request.Create.self).flatMap{ (pRequest) -> Future<Place.Response> in
            var emails = pRequest.emails
            if emails == nil {
                emails = [NamedEmail(name: "Editor", value: user.email)]
            }
            let now = Date()
            let place = Place(id: nil, noun: pRequest.noun, title: pRequest.title, createdAt: now, updatedAt: now, container: pRequest.container, acronym: pRequest.acronym, kind: pRequest.kind, number: pRequest.number, postalCode: pRequest.postalCode, coordinates: pRequest.coordinates, bounding: nil, emails: emails, uris: pRequest.uris, phones: pRequest.phones, afterNumber: pRequest.afterNumber, afterName: pRequest.afterName, complement: pRequest.complement, acl: pRequest.acl)
            //Echo(id: nil, createdAt: now, updatedAt: now, acl: actualAcl, parent: nil, author: user.id!, attachedEvent: nil, location: eRequest.location, fluctuation: EchoController.defaultFluctuation, viewers: nil, device: eRequest.attachedState)
            return place.save(on: req).flatMap { savedPlace in
                return savedPlace.response(req)
            }
        }
    }
    
    ///
    public func add(_ req: Request) throws -> Future<Place.Response> {
        // decode request content
        throw Abort(HTTPResponseStatus.notImplemented)
    }
}

/// - MARK - CHANNEL UPDATE

extension PlaceController {
    /// Update an user using User.Request.Update
    public func update(_ req: Request) throws -> Future<Place.Response> {
        // decode request parameter (todos/:id)
        return try req.parameters.next(User.self).flatMap { uToUpdate -> Future<Place.Response> in
            // fetch auth'd user
            let _ = try UserController.checkLoginRelated(req, uToUpdate)
            
            throw Abort(HTTPResponseStatus.notImplemented)
        }
    }
    
    /// Create User Profile Picture
    public func updateProfilePicture(_ req: Vapor.Request) throws -> Future<String> {
        throw Abort(HTTPResponseStatus.notImplemented)
        
    }
    
    /// Add User's Position
    public func addUserPosition(_ req: Vapor.Request) throws -> Future<Place.Response> {
        throw Abort(HTTPResponseStatus.notImplemented)
        
    }
    
    public func updateUserPosition(_ req: Vapor.Request) throws -> Future<Place.Response> {
        throw Abort(HTTPResponseStatus.notImplemented)
    }
    // /u/:uid/pos/:posid
    public func deleteUserPosition(_ req: Vapor.Request) throws -> Future<Place.Response> {
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
    public func list(_ req: Request) throws -> Future<[Place.Response]> {
        throw Abort(HTTPResponseStatus.notImplemented)
    }
    
    /// Show an user.
    public func show(_ req: Request) throws -> Future<Place.Response> {
        throw Abort(HTTPResponseStatus.notImplemented)
    }
    
    
    /// List User's Position
    public func userPositions(_ req: Vapor.Request) throws -> Future<[Place.Response]> {
        throw Abort(HTTPResponseStatus.notImplemented)
    }
    
}
