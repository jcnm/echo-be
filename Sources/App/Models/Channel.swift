//
//  Channel.swift
//  App
//
//  Created by J. Charles N. M. on 17/09/2018.
//


import Authentication
import FluentSQLite
import Vapor

public final class Channel: AdoptedModel  {

    public static let name = "channel"
    /// Can be `nil` if the object has not been saved yet.
    public var id: Channel.ID?
    /** Object-Access Control Level */
    public var acl: ACL
    /** Creation date */
    public var createdAt: Date
    /** Updated date */
    public var updatedAt: Date
    /** Client App owner */
    public var owner: User.ID
    /** Channel full name */
    public var title: String
    /** Channel short name */
    public var shortName: String?
    /** Channel type  * 1 : **Developer** channel * 2 : **Partner** channel * 4 : **Authority** * 8 : **Official** echo channel */
    public var kind: ChannelKind.RawValue
    /** Authentification API Key */
    public var apiKey: String
    /** Authentification API Secret Key */
    public var clientSecret: String
    /** Uris list for this Application */
    public var uris: [NamedURI]?
    /** Email list for this application */
    public var emails: [NamedEmail]
    /** Associated place to this given channel */
    public var places: [Place.ID]?
    
    
    public init(id: Channel.ID?, createdAt: Date, updatedAt: Date, acl:ACL, owner: User.ID, title: String, shortName: String?, kind: ChannelKind.RawValue, apiKey: String, clientSecret: String, uris: [NamedURI]?, emails: [NamedEmail], places: [Place.ID]?) {
        self.acl = acl
        self.owner = owner
        self.title = title
        self.shortName = shortName
        self.kind = kind
        self.apiKey = apiKey
        self.clientSecret = clientSecret
        self.uris = uris
        self.emails = emails
        self.places = places
        self.id = id
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    public func response(_ req: Vapor.Request) -> Future<Channel.Response> {
        return
            req.future(
                Channel.Response(id: self.id!, acl: self.acl, createdAt: self.createdAt, updatedAt: self.updatedAt, owner: self.owner, name: self.title, shortName: self.shortName, kind: self.kind, apiKey: self.apiKey, clientSecret: self.clientSecret, places: self.places, emails: self.emails, uris: self.uris) )
    }
}

public extension Channel {
    /// Fluent relation to the application that owns this token.
    public var user: Parent<Channel, User> {
        return parent(\.owner)
    }
}

/// Allows `Channel` to be used as a Fluent migration.
extension Channel: Migration { /// See `Migration`.
    public static func prepare(on conn: SQLiteConnection) -> Future<Void> {
        return SQLiteDatabase.create(Channel.self, on: conn) { builder in
            builder.field(for: \.id, isIdentifier: true)
            builder.field(for: \.title)
            builder.field(for: \.createdAt)
            builder.field(for: \.updatedAt)
            builder.field(for: \.owner )
            builder.field(for: \.acl)
            builder.field(for: \.shortName)
            builder.field(for: \.kind)
            builder.field(for: \.apiKey)
            builder.field(for: \.clientSecret)
            builder.field(for: \.uris)
            builder.field(for: \.emails)
            builder.field(for: \.places)
            builder.unique(on: \.id)
        }
    }
}

/// Allows `Channel` to be encoded to and decoded from HTTP messages.
extension Channel: Content { }

/// Allows `Channel` to be used as a dynamic parameter in route definitions.
extension Channel: Parameter { }



// MARK: Content
public extension Channel {
    /// Data required to create a channel.
    public struct Request: Content {
        
        public struct Create: Content {
            /** Object-Access Control Level */
            public var acl: ACL
            /** Client App owner */
            public var owner: User.ID
            /** Channel full name */
            public var name: String
            /** Channel short name */
            public var shortName: String?
            public var kind: ChannelKind.RawValue
            /** Uris list for this Application */
            public var uri: String
            /** Email list for this application */
            public var email: String
            /** Associated place to this given channel */
            public var place: Place

        }
        
        /// Public representation of channel data.
        public struct Update: Content {
            /// Can be `nil` if the object has not been saved yet.
            public var id: Channel.ID
            /** Object-Access Control Level */
            public var acl: ACL
            /** Client App owner */
            public var owner: User.ID
            /** Channel full name */
            public var name: String
            /** Channel short name */
            public var shortName: String?
            public var kind: ChannelKind.RawValue
            /** Authentification API Key */
            public var apiKey: String
            /** Authentification API Secret Key */
            public var clientSecret: String
            /** Addresses attached to this profile */
            public var places: [Place.ID]?
            /** Main emails to contact for this place */
            public var emails: [NamedEmail]?
            /** Main Uris to reach for more information about this place */
            public var uris: [NamedURI]?
        }
        
    }
    
    /// Public representation of channel data.
    public struct Response: Content {
        /// Can be `nil` if the object has not been saved yet.
        public var id: Channel.ID
        /** Object-Access Control Level */
        public var acl: ACL
        /** Creation date */
        public var createdAt: Date
        /** Updated date */
        public var updatedAt: Date
        /** Client App owner */
        public var owner: User.ID
        /** Channel full name */
        public var name: String
        /** Channel short name */
        public var shortName: String?
        public var kind: ChannelKind.RawValue
        /** Authentification API Key */
        public var apiKey: String
        /** Authentification API Secret Key */
        public var clientSecret: String
        /** Addresses attached to this profile */
        public var places: [Place.ID]?
        /** Main emails to contact for this place */
        public var emails: [NamedEmail]?
        /** Main Uris to reach for more information about this place */
        public var uris: [NamedURI]?
    }
}

