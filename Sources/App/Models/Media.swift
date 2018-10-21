//
//  Media.swift
//  App
//
//  Created by J. Charles N. M. on 16/09/2018.
//

import Authentication
import FluentSQLite
import Vapor

public final class Media: AdoptedModel {
    public static let name = "media"
    /// Can be `nil` if the object has not been saved yet.
    public var id: Media.ID?
    /** Object-Access Control Level */
    public var acl: ACL
    /** Creation date */
    public var createdAt: Date
    /** Updated date */
    public var updatedAt: Date
    public var owner: User.ID
    public var attachedEcho: Echo.ID
    /** The data content&#39;s written language */
    public var lang: String
    /** Indicate the kind of data encapsulated into this  media  - 1 - **Text** for message post (by default) - 2 - **Image**  - 4 - **URI** - 8 - **Sound** - 10 - **Video** as an image and sound data - 15 - **Document** as a full mix of the others  */
    public var kind: Int
    /** The full media content now referencing as   */
    public var data: AbsolutePath  // Rename this uri
    /** Data content description if not a simple text type content, otherwise, this is not required. */
    public var descr: String?
    
    
    public init(id:Media.ID? , owner: User.ID, createdAt: Date, updatedAt: Date, acl: ACL, attachedEcho: Echo.ID, lang: String, kind: MediaKind.RawValue, data: AbsolutePath, descr: String?) {
        self.acl            = acl
        self.attachedEcho   = attachedEcho
        self.lang           = lang
        self.kind           = kind
        self.data           = data
        self.descr          = descr
        self.id             = id
        self.owner          = owner
        self.createdAt      = createdAt
        self.updatedAt      = updatedAt
    }
    
}

extension Media {
    /// Fluent relation to the user that owns this token.
    var echo: Parent<Media, Echo> {
        return parent(\.attachedEcho)
    }
    var user: Parent<Media, User> {
        return parent(\.owner)
    }
}


/// Allows `Profile` to be used as a Fluent migration.
extension Media: Migration { /// See `Migration`.
    public static func prepare(on conn: SQLiteConnection) -> Future<Void> {
        return SQLiteDatabase.create(Media.self, on: conn) { builder in
            builder.field(for: \.id, isIdentifier: true)
            builder.field(for: \.createdAt )
            builder.field(for: \.updatedAt)
            builder.field(for: \.acl)
            builder.field(for: \.kind)
            builder.field(for: \.attachedEcho)
            builder.field(for: \.owner)
            builder.field(for: \.lang)
            builder.field(for: \.data)
            builder.field(for: \.descr)
            builder.reference(from: \Media.owner, to: \User.id)
            builder.reference(from: \Media.attachedEcho, to: \Echo.id)
            builder.unique(on: \.id)
        }
    }
}

/// Allows `Media` to be encoded to and decoded from HTTP messages.
extension Media: Content { }

/// Allows `Media` to be used as a dynamic parameter in route definitions.
extension Media: Parameter { }


// MARK: Content
extension Media {

    public struct Request: Content {
        
    /// Data required to create a media.
        public struct Create: Content {
            /** Object-Access Control Level */
            public var acl: ACL
            public var attachedEcho: Echo.ID
            /** The data content&#39;s written language */
            public var lang: String
            /** Indicate the kind of data encapsulated into this  media  - 1 - **Text** for message post (by default) - 2 - **Image**  - 4 - **URI** - 8 - **Sound** - 10 - **Video** as an image and sound data - 15 - **Document** as a full mix of the others  */
            public var kind: Int
            /** The full media content now referencing as PFFile */
            public var data: String
            /** Data content description if not a simple text type content, otherwise, this is not required. */
            public var descr: String?
        }
        
    }
    
    /// Public update of Media
    public struct Update: Content {
        public var id: Media.ID
        public var acl: ACL
        public var attachedEcho: Echo.ID
        /** The data content&#39;s written language */
        public var lang: String
        /** Indicate the kind of data encapsulated into this  media  - 1 - **Text** for message post (by default) - 2 - **Image**  - 4 - **URI** - 8 - **Sound** - 10 - **Video** as an image and sound data - 15 - **Document** as a full mix of the others  */
        public var kind: Int
        /** The full media content now referencing as PFFile */
        public var data: String
        /** Data content description if not a simple text type content, otherwise, this is not required. */
        public var descr: String?
    }
    
    /// Public representation of media data.
    public struct Response: Content {
        public var id: Media.ID
        /** Creation date */
        public var createdAt: Date
        /** Updated date */
        public var updatedAt: Date
        /** Object-Access Control Level */
        public var acl: ACL
        public var attachedEcho: Echo.ID
        /** The data content&#39;s written language */
        public var lang: String
        /** Indicate the kind of data encapsulated into this  media  - 1 - **Text** for message post (by default) - 2 - **Image**  - 4 - **URI** - 8 - **Sound** - 10 - **Video** as an image and sound data - 15 - **Document** as a full mix of the others  */
        public var kind: Int
        /** The full media content now referencing as PFFile */
        public var data: String
        /** Data content description if not a simple text type content, otherwise, this is not required. */
        public var descr: String?
    }
    
}

