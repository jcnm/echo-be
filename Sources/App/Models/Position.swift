//
//  Position.swift
//  App
//
//  Created by J. Charles N. M. on 22/09/2018.
//


import Foundation
import Crypto
import FluentSQLite
import Vapor

public typealias Location       = [Double]

public final class Position: AdoptedModel {
    /// Can be `nil` if the object has not been saved yet.
    public var id: Position.ID?
    /** The attached user &#x60;User&#x60; */
    public var attachedUser: User.ID
    /** User&#39;s name suffix */
    public var location: Location       // latitude, longitude
    public var createdAt: Date
    public var deleteDate: Date?
    
    public init(id: Position.ID?, attachedUser: User.ID, location: Location /*lat, lon*/,
        createdAt: Date, deleteDate: Date?) {
        self.id             = id
        self.attachedUser   = attachedUser
        self.location       = location
        self.createdAt     = createdAt
        self.deleteDate     = deleteDate
    }
    
    public func response(_ on: Vapor.Request) -> Position.Response {
        return Response(id: self.id!, attachedUser: self.attachedUser, location: self.location,
                        createdAt: self.createdAt, deleteDate: self.deleteDate)
    }
}


public extension Position {
    var parent: Parent<Position, User> {
        return parent(\.attachedUser)
    }
}


/// Allows `Profile` to be used as a Fluent migration.
extension Position: Migration { /// See `Migration`.
    public static func prepare(on conn: SQLiteConnection) -> Future<Void> {
        return SQLiteDatabase.create(Position.self, on: conn) { builder in
            builder.field(for: \.id, isIdentifier: true)
            builder.field(for: \.attachedUser )
            builder.field(for: \.location)
            builder.field(for: \.createdAt)
            builder.field(for: \.deleteDate)
            builder.reference(from: \Position.attachedUser, to: \User.id)
            builder.unique(on: \.id)
        }
    }
}

/// Allows `Profile` to be encoded to and decoded from HTTP messages.
extension Position: Content { }

/// Allows `Profile` to be used as a dynamic parameter in route definitions.
extension Position: Parameter { }

// MARK: Content
public extension Position {
    
    /// Data required to create and update a profile.
    public struct Request: Content {
        public struct Create: Content {
            /** The attached user &#x60;User&#x60; */
            public var attachedUser: User.ID
            /** User&#39;s name suffix */
            public var location: [Double]       // latitude, longitude
        }
        
        public struct Update: Content {
            public var id: Position.ID
            /** User&#39;s name suffix */
            public var location: Location?       // latitude, longitude
            public var createdAt: Date?
            public var deleteDate: Date?
        }
    }
    
    /// Public representation of profil data.
    public struct Response: Content {
        public var id: Position.ID
        /** The attached user &#x60;User&#x60; */
        public var attachedUser: User.ID
        /** User&#39;s name suffix */
        public var location: Location       // latitude, longitude
        public var createdAt: Date
        public var deleteDate: Date?
    }
}

