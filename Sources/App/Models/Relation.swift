//
//  Relation.swift
//  App
//
//  Created by J. Charles N. M. on 16/09/2018.
//

import Authentication
import FluentSQLite
import Vapor

final class Relation: AdoptedPivot
{
    public static let name = "relation"
    /// Can be `nil` if the object has not been saved yet.
    public var id: Relation.ID?
    /** Object-Access Control Level */
    public var acl: ACL
    /** Creation date */
    public var createdAt: Date
    /** Updated date */
    public var updatedAt: Date

    typealias Left = User
    typealias Right = User

    static var leftIDKey: LeftIDKey = \.fromUser
    static var rightIDKey: RightIDKey = \.toUser

    public var fromUser: User.ID
    public var toUser: User.ID
    /** Relation title */
    public var title: String
    /** Formal Relation type &#x60;UserRelationKind&#x60;  - 0 : **Knowledge** - 1 : **OldFriend** - 2 : **Friend** - 4 : **CloseFriend** - 8 : **Workmate** - 16 : **Roommate** - 32: **Family** */
    public var kind: Int
    /** Begining relation date */
    public var since: Date?
    // If bilaterated validated
    public var validated: Bool = false // By default any relation is not yet validated

    public init(id: Relation.ID?, createdAt: Date, updatedAt: Date, fromUser: User.ID, toUser: User.ID, title: String, kind: Int, since: Date?, acl: ACL) {
        self.fromUser   = fromUser
        self.toUser     = toUser
        self.title      = title
        self.kind       = kind
        self.since      = since
        self.acl        = acl
        self.validated  = false
        self.id        = id
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}


/// Allows `Profile` to be used as a Fluent migration.
extension Relation: Migration { /// See `Migration`.
    public static func prepare(on conn: SQLiteConnection) -> Future<Void> {
        return SQLiteDatabase.create(Relation.self, on: conn) { builder in
            builder.field(for: \.id, isIdentifier: true)
            builder.field(for: \.createdAt )
            builder.field(for: \.updatedAt)
            builder.field(for: \.acl)
            builder.field(for: \.kind)
            builder.field(for: \.fromUser)
            builder.field(for: \.toUser)
            builder.field(for: \.title)
            builder.field(for: \.since)
            builder.field(for: \.validated)
            builder.unique(on: \.id)
        }
    }
}

/// Allows `Profile` to be encoded to and decoded from HTTP messages.
extension Relation: Content { }

/// Allows `Profile` to be used as a dynamic parameter in route definitions.
extension Relation: Parameter { }


// MARK: Content
extension Relation {
    /// Data required to create a user.
    public struct Request: Content {
        
        public struct Create: Content {
            public var fromUser: User.ID
            public var toUser: User.ID
            /** Relation title */
            public var title: String
            /** Formal Relation type &#x60;UserRelationKind&#x60;  - 0 : **Knowledge** - 1 : **OldFriend** - 2 : **Friend** - 4 : **CloseFriend** - 8 : **Workmate** - 16 : **Roommate** - 32: **Family** */
            public var kind: Int
            /** Begining relation date */
            public var since: Date
        }
        
    }
    
    /// Public update of Media
    public struct Update: Content {
        public var id: Media.ID
        public var fromUser: User.ID
        public var toUser: User.ID
        /** Relation title */
        public var title: String
        public var kind: Int
        /** Begining relation date */
        public var since: Date?
        // If bilaterated validated
        public var validated: Bool
        
    }
    
    /// Public representation of media data.
    public struct Response: Content {
        public var id: Media.ID
        /** Creation date */
        public var createdAt: Date
        /** Updated date */
        public var updatedAt: Date
        public var fromUser: User.ID
        public var toUser: User.ID
        /** Relation title */
        public var title: String
        public var kind: Int
        /** Begining relation date */
        public var since: Date?
        // If bilaterated validated
        public var validated: Bool
    }
    
}

