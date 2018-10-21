//
//  Ripple.swift
//  App
//
//  Created by J. Charles N. M. on 16/09/2018.
//

import Authentication
import FluentSQLite
import Vapor

final public class Ripple: AdoptedModel {

    public static let name = "ripple"
    /// Can be `nil` if the object has not been saved yet.
    public var id: Ripple.ID?
    /** Object-Access Control Level */
    public var acl: ACL
    /** Creation date */
    public var createdAt: Date
    /** Updated date */
    public var updatedAt: Date

    public var attachedEcho: Echo.ID
    /** Author of the ripple */
    public var author: User.ID
    public var location: Location?
    /** How this ripple happen ?  * 1 &#x3D; **Passive** * 2 &#x3D; **Active**  * 3 &#x3D; **SemiActive** */
    public var kind: Int
    /** Given ripple score do say if this is  * 8 &#x3D; **Awesome** * 4 &#x3D; **Fine** * 2 &#x3D; **Freaking**  * 1 &#x3D; **Ripple** */
    public var score: Int
    /** Did this ripple is specificaly  for the event ? This allows splitting event ripples from specific echo attached to an event ripples. */
    public var event: Bool
    
    
    
    public init(id: Ripple.ID?, createdAt: Date, updatedAt: Date, acl: ACL, attachedEcho: Echo.ID, author: User.ID, location: Location?, kind: Int, score: Int, event: Bool) {
        self.acl = acl
        self.attachedEcho = attachedEcho
        self.author = author
        self.location = location
        self.kind = RippleKind(rawValue: kind)?.rawValue ?? RippleKind.semiActive.rawValue
        self.score = score
        self.event = event
        self.id = id
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

}

extension Ripple {
    /// Fluent relation to the user that owns this token.
    var echo: Parent<Ripple, Echo> {
        return parent(\.attachedEcho)
    }
    var user: Parent<Ripple, User> {
        return parent(\.author)
    }
}


/// Allows `Profile` to be used as a Fluent migration.
extension Ripple: Migration { /// See `Migration`.
    public static func prepare(on conn: SQLiteConnection) -> Future<Void> {
        return SQLiteDatabase.create(Ripple.self, on: conn) { builder in
            builder.field(for: \.id, isIdentifier: true)
            builder.field(for: \.createdAt )
            builder.field(for: \.updatedAt)
            builder.field(for: \.acl)
            builder.field(for: \.kind)
            builder.field(for: \.attachedEcho)
            builder.field(for: \.author)
            builder.field(for: \.location)
            builder.field(for: \.score)
            builder.field(for: \.event)
            builder.unique(on: \.id)
        }
    }
}

/// Allows `Profile` to be encoded to and decoded from HTTP messages.
extension Ripple: Content { }

/// Allows `Profile` to be used as a dynamic parameter in route definitions.
extension Ripple: Parameter { }



// MARK: Content
extension Ripple {
    /// Data required to create a ripple.
    public struct Request: Content {
        
        public struct Create: Content {
            /** Creation date */
            public var createdAt: Date
            /** Updated date */
            public var updatedAt: Date
            /** Object-Access Control Level */
            public var ACL: ACL?
            public var attachedEcho: Echo.ID
            /** Author of the ripple */
            public var author: User.ID
            public var location: Location?
            /** How this ripple happen ?  * 1 &#x3D; **Passive** * 2 &#x3D; **Active**  * 3 &#x3D; **SemiActive** */
            public var kind: Int
            /** Given ripple score do say if this is  * 8 &#x3D; **Awesome** * 4 &#x3D; **Fine** * 2 &#x3D; **Freaking**  * 1 &#x3D; **Ripple** */
            public var score: Int
            /** Did this ripple is specificaly  for the event ? This allows splitting event ripples from specific echo attached to an event ripples. */
            public var event: Bool?
        }
        
        /// Public representation of ripple data.
        public struct Update: Content {
            /// Can be `nil` if the object has not been saved yet.
            public var id: Ripple.ID
            /** Creation date */
            public var createdAt: Date?
            /** Updated date */
            public var updatedAt: Date?
            /** Object-Access Control Level */
            public var ACL: ACL
            public var attachedEcho: Echo.ID?
            /** Author of the ripple */
            public var author: User.ID?
            public var location: Location?
            /** How this ripple happen ?  * 1 &#x3D; **Passive** * 2 &#x3D; **Active**  * 3 &#x3D; **SemiActive** */
            public var kind: Int?
            /** Given ripple score do say if this is  * 8 &#x3D; **Awesome** * 4 &#x3D; **Fine** * 2 &#x3D; **Freaking**  * 1 &#x3D; **Ripple** */
            public var score: Int?
            /** Did this ripple is specificaly  for the event ? This allows splitting event ripples from specific echo attached to an event ripples. */
            public var event: Bool?
        }
        
    }
    
    /// Public representation of ripple data.
    public struct Response: Content {
        /// Can be `nil` if the object has not been saved yet.
        public var id: Ripple.ID
        /** Creation date */
        public var createdAt: Date
        /** Updated date */
        public var updatedAt: Date
        /** Object-Access Control Level */
        public var ACL: ACL
        public var attachedEcho: Echo.ID
        /** Author of the ripple */
        public var author: User.ID
        public var location: Location
        /** How this ripple happen ?  * 1 &#x3D; **Passive** * 2 &#x3D; **Active**  * 3 &#x3D; **SemiActive** */
        public var kind: Int
        /** Given ripple score do say if this is  * 8 &#x3D; **Awesome** * 4 &#x3D; **Fine** * 2 &#x3D; **Freaking**  * 1 &#x3D; **Ripple** */
        public var score: Int
        /** Did this ripple is specificaly  for the event ? This allows splitting event ripples from specific echo attached to an event ripples. */
        public var event: Bool
    }
    
}

