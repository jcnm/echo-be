//
//  Echo.swift
//  App
//
//  Created by J. Charles N. M. on 17/09/2018.
//


import Authentication
import FluentSQLite
import Vapor

public final class Echo: AdoptedModel {
    public static let name = "echo"
    /// Can be `nil` if the object has not been saved yet.
    public var id: Echo.ID?
    /** Object-Access Control Level */
    public var acl: ACL
    /** Creation date */
    public var createdAt: Date
    /** Updated date */
    public var updatedAt: Date
    /** Echo parent */
    public var parent: ObjectID?
    /** Echo author */
    public var author: ObjectID
    /** Attached Event if so */
    public var attachedEvent: ObjectID?
    public var location: Location
    public var fluctuation: Fluctuation
    /** Allowed user list if not null */
    public var viewers: [User.ID]?
    /** Capturing state during the echo submition */
    public var device: Device?
    
    public init(id: Echo.ID?, createdAt: Date, updatedAt: Date, acl: ACL, parent: Echo.ID?, author: User.ID, attachedEvent: Event.ID?, location: Location, fluctuation: Fluctuation, viewers: [User.ID]?, device: Device?) {
        self.acl = acl
        self.parent = parent
        self.author = author
        self.attachedEvent = attachedEvent
        self.location = location
        self.fluctuation = fluctuation
        self.viewers = viewers
        self.device = device
        self.id = id
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    
    public func response(_ req: Vapor.Request) throws -> Future<Echo.Response> {
        /// 3 queries with SQL language, could be done with one query
        return try self.contents.query(on: req).sort(\.createdAt).all().flatMap{ medias in
            return try self.ripples.query(on: req).sort(\.createdAt).all().flatMap{ ripples in
                return try self.witnesses.query(on: req).sort(\.createdAt).all().flatMap{ witnesses in
                    return req.future(Echo.Response(id: self.id!, createdAt: self.createdAt, updatedAt: self.updatedAt, acl: self.acl, parent: self.parent, author: self.author, attachedEvent: self.attachedEvent, location: self.location, fluctuation: self.fluctuation, viewers: self.viewers, witnesses: witnesses, ripples: ripples, contents: medias, state: self.device))
                }
            }
        }
    }
    
    public func response(_ req: Vapor.Request, medias: [Media]) throws -> Future<Echo.Response> {
        /// 2 queries with SQL language, could be done with one query
        return try self.ripples.query(on: req).sort(\.createdAt).all().flatMap{ ripples in
            return try self.witnesses.query(on: req).sort(\.createdAt).all().flatMap{ witnesses in
                return self.response(req, medias: medias, ripples: ripples, witnesses: witnesses)
            }
        }
    }
    
    public func response(_ req: Vapor.Request, ripples: [Ripple]) throws -> Future<Echo.Response> {
        /// 2 queries with SQL language, could be done with one query
        return try self.contents.query(on: req).sort(\.createdAt).all().flatMap{ medias in
            return try self.witnesses.query(on: req).sort(\.createdAt).all().flatMap{ witnesses in
                return self.response(req, medias: medias, ripples: ripples, witnesses: witnesses)
            }
        }
    }
    
    public func response(_ req: Vapor.Request, witnesses: [Witness]) throws -> Future<Echo.Response> {
        /// 2 queries with SQL language, could be done with one query
        return try self.contents.query(on: req).sort(\.createdAt).all().flatMap{ medias in
            return try self.ripples.query(on: req).sort(\.createdAt).all().flatMap{ ripples in
                return self.response(req, medias: medias, ripples: ripples, witnesses: witnesses)
            }
        }
    }

    public func response(_ req: Vapor.Request, medias: [Media], ripples: [Ripple], witnesses: [Witness])  -> Future<Echo.Response> {
        return req.future(Echo.Response(id: self.id!, createdAt: self.createdAt, updatedAt: self.updatedAt, acl: self.acl, parent: self.parent, author: self.author, attachedEvent: self.attachedEvent, location: self.location, fluctuation: self.fluctuation, viewers: self.viewers, witnesses: witnesses, ripples: ripples, contents: medias, state: self.device))
    }
}


extension Echo {
    /// Fluent relation to the user that owns this token.
    public var father: Parent<Echo, Echo>? {
        return parent(\.parent)
    }
    
    public var user: Parent<Echo, User> {
        return parent(\.author)
    }
    
    public var witnesses: Children<Echo, Witness> {
        return children(\.attachedEcho)
    }
    
    public var ripples: Children<Echo, Ripple> {
        return children(\.attachedEcho)
    }
    /** Media content, as array to allow to upload multiple file for a sane post */
    public var contents: Children<Echo, Media> {
        return children(\.attachedEcho)
    }

}


/// Allows `Echo` to be used as a Fluent migration.
extension Echo: Migration { /// See `Migration`.
    public static func prepare(on conn: SQLiteConnection) -> Future<Void> {
        return SQLiteDatabase.create(Echo.self, on: conn) { builder in
            builder.field(for: \.id, isIdentifier: true)
            builder.field(for: \.createdAt)
            builder.field(for: \.updatedAt)
            builder.field(for: \.acl)
            builder.field(for: \.parent)
            builder.field(for: \.attachedEvent)
            builder.field(for: \.author)
            builder.field(for: \.location)
            builder.field(for: \.fluctuation)
            builder.field(for: \.viewers)
            builder.field(for: \.contents)
            builder.field(for: \.device)
            builder.unique(on: \.id)
        }
    }
}

/// Allows `Echo` to be encoded to and decoded from HTTP messages.
extension Echo: Content { }

/// Allows `Echo` to be used as a dynamic parameter in route definitions.
extension Echo: Parameter { }



// MARK: Content
extension Echo {
    /// Data required to create an echo.
    public struct Request: Content {
        public struct Create: Content {
            /** Object-Access Control Level */
            public var acl: ACL?
            /** Echo parent */
            public var parent: Echo.ID?
            /** Echo author */
            public var author: User.ID
            /** Attached Event if so */
            public var attachedEvent: Event.ID?
            public var location: Location
            public var content: String
            public var lang: String
            public var data: File?
            /** Capturing state during the echo submition */
            public var attachedState: Device?
        }
        
        /// Public common representation update of echo data.
        public struct Update: Content {
            public var id: Echo.ID?
            /** Object-Access Control Level */
            public var acl: ACL
            /** Echo parent */
            public var parent: Echo.ID?
            /** Echo author */
            public var author: User.ID
            /** Attached Event if so */
            public var attachedEvent: Event.ID?
            public var location: Location
            public var fluctuation: Fluctuation
            /** Allowed user list if not null */
            public var viewers: [User.ID]?
            /** Participation to the echo */
            public var witnesses: [Witness.ID]?
            /** Ripples list */
            public var ripples: [Ripple.ID]?
            /** Media content, as array to allow to upload multiple file for a sane post */
            public var contents: [Media.ID]
        }
    }
    
    /// Public representation of echo data.
    public struct Response: Content {
        public var id: Echo.ID
        /** Creation date */
        public var createdAt: Date
        /** Updated date */
        public var updatedAt: Date
        /** Object-Access Control Level */
        public var acl: ACL
        /** Echo parent */
        public var parent: Echo.ID?
        /** Echo author */
        public var author: User.ID
        /** Attached Event if so */
        public var attachedEvent: Event.ID?
        public var location: Location
        public var fluctuation: Fluctuation
        /** Allowed user list if not null */
        public var viewers: [User.ID]?
        /** Participation to the echo */
        public var witnesses: [Witness]?
        /** Ripples list */
        public var ripples: [Ripple]?
        /** Media content, as array to allow to upload multiple file for a sane post */
        public var contents: [Media]
        public var state: Device?
    }
}



