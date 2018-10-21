//
//  Monitor.swift
//  App
//
//  Created by J. Charles N. M. on 16/09/2018.
//


import Authentication
import FluentSQLite
import Vapor

// Represente multi party exchange with a master
public final class Monitor: AdoptedModel {

    public static let name = "monitor"
    /// Can be `nil` if the object has not been saved yet.
    public var id: Monitor.ID?
    /** Object-Access Control Level */
    public var acl: ACL
    /** Creation date */
    public var createdAt: Date
    /** Updated date */
    public var updatedAt: Date

    /** */
    public var owner: User.ID
    /** Attached channel using &#x60;Channel&#x60; type */
    public var client: Channel.ID
    /** Monitor name, intented to overwrite the event&#39;s name if given. */
    public var title: String
    /** Authorized moderators  (should be updated to allow acl attribution for each moderator) */
    public var moderators: [User.ID]?
    /** Authorized channels to acces to this monitor private data */
    public var channels: [Channel.ID]?
    /** Etheir this monitoring allows bidirectinnal communication or not. */
    public var bidirectional: Bool
    /** Participant limitation 0 if no limitation */
    public var limit: Int?
    /** Monitor security access key */
    public var key: String
    /** Connection type:  * 1 : **Text** only * 2 : **Object** exchange (i.e image, sound) * 2: **Audio** call * 4: **Video** call */
    public var connection: MonitorConnection.RawValue
    /** Monitor type:  * 1: **User** monitoring * 2: **Partener** monitoring * 4: **Social** monitoring * 8: **Authority** monitoring * 16: **Staff** monitoring */
    public var kind: MonitorAuthority.RawValue
    
    
    
    public init(id: Monitor.ID?, createdAt: Date, updatedAt: Date, acl: ACL, owner: User.ID, client: Channel.ID, title: String, moderators: [User.ID]?, channels: [Channel.ID]?, bidirectional: Bool, limit: Int?, connection: MonitorConnection.RawValue, kind: MonitorAuthority.RawValue, key: String) {
        self.acl = acl
        self.owner = owner
        self.client = client
        self.title = title
        self.moderators = moderators
        self.channels = channels
        self.bidirectional = bidirectional 
        self.limit = limit
        self.connection = connection
        self.kind = kind
        self.id = id
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.key = key
    }
}


extension Monitor {
    /// Fluent relation to the user that owns this monitor.
    var user: Parent<Monitor, User> {
        return parent(\.owner)
    }
    var chan: Parent<Monitor, Channel> {
        return parent(\.client)
    }
}


/// Allows `Monitor` to be used as a Fluent migration.
extension Monitor: Migration { /// See `Migration`.
    public static func prepare(on conn: SQLiteConnection) -> Future<Void> {
        return SQLiteDatabase.create(Monitor.self, on: conn) { builder in
            builder.field(for: \.id, isIdentifier: true)
            builder.field(for: \.title)
            builder.field(for: \.createdAt)
            builder.field(for: \.updatedAt)
            builder.field(for: \.acl)
            builder.field(for: \.kind)
            builder.field(for: \.client)
            builder.field(for: \.owner)
            builder.field(for: \.moderators)
            builder.field(for: \.channels)
            builder.field(for: \.bidirectional)
            builder.field(for: \.limit)
            builder.field(for: \.connection)
            builder.field(for: \.key)
            builder.unique(on: \.id)
        }
    }
}

/// Allows `Monitor` to be encoded to and decoded from HTTP messages.
extension Monitor: Content { }

/// Allows `Monitor` to be used as a dynamic parameter in route definitions.
extension Monitor: Parameter { }


// MARK: Content
extension Monitor {
    struct Request: Content {
        
        /// Data required to create a monitor.
        public struct Create: Content {
            /** Object-Access Control Level */
            public var acl: ACL
            public var owner: User.ID
            /** Attached channel using &#x60;Channel&#x60; type */
            public var client: Channel.ID
            /** Monitor name, intented to overwrite the event&#39;s name if given. */
            public var name: String
            /** Authorized moderators  (should be updated to allow acl attribution for each moderator) */
            public var moderators: [User.ID]?
            /** Authorized channels to acces to this monitor private data */
            public var channels: [Channel.ID]?
            /** Etheir this monitoring allows bidirectinnal communication or not. */
            public var bidirectional: Bool
            /** Participant limitation 0 if no limitation */
            public var limit: Int?
            /** Connection type:  * 1 : **Text** only * 2 : **Object** exchange (i.e image, sound) * 2: **Audio** call * 4: **Video** call */
            public var connection: MonitorConnection.RawValue
            /** Monitor type:  * 1: **User** monitoring * 2: **Partener** monitoring * 4: **Social** monitoring * 8: **Authority** monitoring * 16: **Staff** monitoring */
            public var kind: MonitorAuthority.RawValue
        }
        
    }
    
    /// Public update of a monitor
    public struct Update: Content {
        public var id: Monitor.ID
        public var acl: ACL
        public var owner: User.ID
        /** Attached channel using &#x60;Channel&#x60; type */
        public var client: Channel.ID
        /** Monitor name, intented to overwrite the event&#39;s name if given. */
        public var name: String
        /** Authorized moderators  (should be updated to allow acl attribution for each moderator) */
        public var moderators: [User.ID]?
        /** Authorized channels to acces to this monitor private data */
        public var channels: [Channel.ID]?
        /** Etheir this monitoring allows bidirectinnal communication or not. */
        public var bidirectional: Bool
        /** Participant limitation 0 if no limitation */
        public var limit: Int?
        /** Connection type:  * 1 : **Text** only * 2 : **Object** exchange (i.e image, sound) * 2: **Audio** call * 4: **Video** call */
        public var connection: MonitorConnection.RawValue
        /** Monitor type:  * 1: **User** monitoring * 2: **Partener** monitoring * 4: **Social** monitoring * 8: **Authority** monitoring * 16: **Staff** monitoring */
        public var kind: MonitorAuthority.RawValue
    }
    
    /// Public representation of monitor data.
    public struct Response: Content {
        public var id: Monitor.ID?
        public var owner: User.ID
        /** Creation date */
        public var createdAt: Date
        /** Updated date */
        public var updatedAt: Date
        /** Attached channel using &#x60;Channel&#x60; type */
        public var client: Channel.ID
        /** Monitor name, intented to overwrite the event&#39;s name if given. */
        public var name: String
        /** Authorized moderators  (should be updated to allow acl attribution for each moderator) */
        public var moderators: [User.ID]?
        /** Authorized channels to acces to this monitor private data */
        public var channels: [Channel.ID]?
        /** Etheir this monitoring allows bidirectinnal communication or not. */
        public var bidirectional: Bool
        /** Participant limitation 0 if no limitation */
        public var limit: Int?
        /** Connection type:  * 1 : **Text** only * 2 : **Object** exchange (i.e image, sound) * 2: **Audio** call * 4: **Video** call */
        public var connection: MonitorConnection.RawValue
        /** Monitor type:  * 1: **User** monitoring * 2: **Partener** monitoring * 4: **Social** monitoring * 8: **Authority** monitoring * 16: **Staff** monitoring */
        public var kind: MonitorAuthority.RawValue
    }
    
}


