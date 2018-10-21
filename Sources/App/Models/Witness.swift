//
//  Witness.swift
//  App
//
//  Created by J. Charles N. M. on 16/09/2018.
//


import Authentication
import FluentSQLite
import Vapor

public final class Witness: AdoptedModel {
    
    public static let name = "witness"
    /// Can be `nil` if the object has not been saved yet.
    public var id: Witness.ID?
    /** Object-Access Control Level */
    public var acl: ACL
    /** Creation date */
    public var createdAt: Date
    /** Updated date */
    public var updatedAt: Date

    public var attachedEcho: Echo.ID
    public var author: User.ID
    public var location: Location?
    /** How this witness happen ?   * 1 : **Urged**  * 2 : **Active** */
    public var kind: Int
    /** Given witness score  * 4 :**Present** I was there  * 2 : **Truth** this real not hoax * 1 : **Maybe** to confirm * 0 : **Fake**  this an hoax  A given event!echo with too many witness designing it as fake will be deleted in long term (long term means a week or less). */
    public var score: WitnessScore.RawValue
    public var event: Bool
 
    
    
    public init(id: Witness.ID?, createdAt: Date, updatedAt: Date, acl: ACL, attachedEcho: Echo.ID, author: User.ID, location: Location, kind: Int, score: WitnessScore.RawValue, event: Bool) {

        self.acl = acl
        self.attachedEcho = attachedEcho
        self.author = author
        self.location = location
        self.kind = kind
        self.score = score
        self.event = event
        self.id = id
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}


extension Witness {
    /// Fluent relation to the user that owns this token.
    var user: Parent<Witness, User> {
        return parent(\.author)
    }
    var echo: Parent<Witness, Echo> {
        return parent(\.attachedEcho)
    }
    
}


/// Allows `Profile` to be used as a Fluent migration.
extension Witness: Migration { /// See `Migration`.
    public static func prepare(on conn: SQLiteConnection) -> Future<Void> {
        return SQLiteDatabase.create(Witness.self, on: conn) { builder in
            builder.field(for: \.id, isIdentifier: true)
            builder.field(for: \.createdAt )
            builder.field(for: \.updatedAt)
            builder.field(for: \.acl)
            builder.field(for: \.author)
            builder.field(for: \.attachedEcho)
            builder.field(for: \.kind)
            builder.field(for: \.score)
            builder.field(for: \.location)
            builder.field(for: \.event)
            builder.unique(on: \.id)
        }
    }
}

/// Allows `Profile` to be encoded to and decoded from HTTP messages.
extension Witness: Content { }

/// Allows `Profile` to be used as a dynamic parameter in route definitions.
extension Witness: Parameter { }



// MARK: Content
extension Witness {
    /// Data required to create a user.
    public struct Request: Content {
        public struct Create: Content {
            public var acl: ACL
            public var attachedEcho: Echo.ID
            public var author: User.ID
            public var location: Location?
            /** How this witness happen ?   * 1 : **Urged**  * 2 : **Active** */
            public var kind: Int
            /** Given witness score  * 4 :**Present** I was there  * 2 : **Truth** this real not hoax * 1 : **Maybe** to confirm * 0 : **Fake**  this an hoax  A given event!echo with too many witness designing it as fake will be deleted in long term (long term means a week or less). */
            public var score: Int
            public var event: Bool
            
        }
        
        public struct Update: Content {
            public var id: Witness.ID
            /** Object-Access Control Level */
            public var acl: ACL
            public var attachedEcho: Echo.ID
            public var author: User.ID
            public var location: Location?
            /** How this witness happen ?   * 1 : **Urged**  * 2 : **Active** */
            public var kind: Int
            /** Given witness score  * 4 :**Present** I was there  * 2 : **Truth** this real not hoax * 1 : **Maybe** to confirm * 0 : **Fake**  this an hoax  A given event!echo with too many witness designing it as fake will be deleted in long term (long term means a week or less). */
            public var score: WitnessScore.RawValue
            public var event: Bool
        }
    }
    
    /// Public representation of user data.
    public struct Response: Content {
        public var id: Witness.ID
        /** Creation date */
        public var createdAt: Date
        /** Updated date */
        public var updatedAt: Date
        public var acl: ACL
        public var attachedEcho: Echo.ID
        public var author: User.ID
        public var location: Location?
        /** How this witness happen ?   * 1 : **Urged**  * 2 : **Active** */
        public var kind: Int
        /** Given witness score  * 4 :**Present** I was there  * 2 : **Truth** this real not hoax * 1 : **Maybe** to confirm * 0 : **Fake**  this an hoax  A given event!echo with too many witness designing it as fake will be deleted in long term (long term means a week or less). */
        public var score: WitnessScore.RawValue
        public var event: Bool

    }
}
