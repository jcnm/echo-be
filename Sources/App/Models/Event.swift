//
//  Event.swift
//  App
//
//  Created by J. Charles N. M. on 17/09/2018.
//


import Authentication
import FluentSQLite
import Vapor

// An event can be an private conversation,
// organized evenement, gala, preventive plan etc
// Random evenement like live representation, attentat etc... (generated one)
final public class Event: AdoptedModel {

    public static let name = "event"
    /// Can be `nil` if the object has not been saved yet.
    public var id: Event.ID?
    /** Object-Access Control Level */
    public var acl: ACL
    /** Creation date */
    public var createdAt: Date
    /** Updated date */
    public var updatedAt: Date
    /** Main echo &#x60;Echo&#x60; */
    public var leader: Echo.ID
    public var endDate: Date?
    /** Event average fluctuation */
    public var fluctuation: Fluctuation
    /** Attached pool &#x60;Pool&#x60; */
    public var attachedPool: ObjectID?
    /** **&#x60;EventKind&#x60;** What sort of event is this ?   - **Inbox**   - 0   - **Generated**  - 1  - by default   - **Planned**   - 2 - for every organized event (gala, concert, party and so on)   - **Prevention** - 4 - for prevention message from authorities, rescues parteners   - **Information**  - 8 - informative messages from authorities, rescues and staff  */
    public var kind: EventKind.RawValue
    /** Allowed user list if not null */
    public var viewers: [User.ID]?
    
    
    
    public init(id: Event.ID?, createdAt: Date, updatedAt: Date, acl: ACL, leader: Echo.ID,
                endDate: Date?, fluctuation: Fluctuation, attachedPool: ObjectID?,
                kind: EventKind.RawValue, viewers: [User.ID]?) {
        self.acl            = acl
        self.leader         = leader
        self.endDate        = endDate
        self.fluctuation    = fluctuation
        self.attachedPool   = attachedPool
        self.kind           = kind
        self.viewers        = viewers
        
        self.id        = id
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        
    }
}

extension Event {
    /// Fluent relation to the user that owns this token.
    //    var pool: Parent<Event, Pool> {
    //        return parent(\.attachedPool)
    //    }
    var lead: Parent<Event, Echo> {
        return parent(\.leader)
    }
    var echos: Children<Event, Echo>? {
        return children(\.attachedEvent)
    }

}


/// Allows `Profile` to be used as a Fluent migration.
extension Event: Migration { /// See `Migration`.
    public static func prepare(on conn: SQLiteConnection) -> Future<Void> {
        return SQLiteDatabase.create(Event.self, on: conn) { builder in
            builder.field(for: \.id, isIdentifier: true)
            builder.field(for: \.createdAt )
            builder.field(for: \.updatedAt)
            builder.field(for: \.acl)
            builder.field(for: \.leader)
            builder.field(for: \.endDate)
            builder.field(for: \.attachedPool)
            builder.field(for: \.kind)
            builder.field(for: \.fluctuation)
            builder.field(for: \.viewers)
            builder.unique(on: \.id)
        }
    }
}

/// Allows `Profile` to be encoded to and decoded from HTTP messages.
extension Event: Content { }

/// Allows `Profile` to be used as a dynamic parameter in route definitions.
extension Event: Parameter { }



// MARK: Content
extension Event {
    /// Data required to create an event.
    struct Request: Content {
        struct Create: Content {
            /** Object-Access Control Level */
            public var acl: ACL
            /** Echo parent */
            public var leader: Echo.ID
            public var endDate: Date?
            /** Attached pool &#x60;Pool&#x60; */
            public var attachedPool: ObjectID?
            /** **&#x60;EventKind&#x60;** What sort of event is this ?   - **Inbox**   - 0   - **Generated**  - 1  - by default   - **Planned**   - 2 - for every organized event (gala, concert, party and so on)   - **Prevention** - 4 - for prevention message from authorities, rescues parteners   - **Information**  - 8 - informative messages from authorities, rescues and staff  */
            public var kind: EventKind.RawValue
        }
        
        /// Public common representation update of event data.
       struct Update: Content {
            public var id: Event.ID
            /** Object-Access Control Level */
            public var acl: ACL
            /** Main echo &#x60;Echo&#x60; */
            public var leader: Echo.ID
            public var endDate: Date?
            /** Event average fluctuation */
            public var fluctuation: Fluctuation
            /** Attached pool &#x60;Pool&#x60; */
            public var attachedPool: ObjectID?
            /** **&#x60;EventKind&#x60;** What sort of event is this ?   - **Inbox**   - 0   - **Generated**  - 1  - by default   - **Planned**   - 2 - for every organized event (gala, concert, party and so on)   - **Prevention** - 4 - for prevention message from authorities, rescues parteners   - **Information**  - 8 - informative messages from authorities, rescues and staff  */
            public var kind: EventKind.RawValue
            /** Allowed user list if not null */
            public var viewers: [User.ID]?
        }
    }
    
    /// Public representation of event data.
    struct Response: Content {
        public var id: Event.ID
        /** Object-Access Control Level */
        public var acl: ACL
        /** Creation date */
        public var createdAt: Date
        /** Updated date */
        public var updatedAt: Date
        public var endDate: Date?
        /** Main echo &#x60;Echo&#x60; */
        public var leader: Echo.ID
        /** Event average fluctuation */
        public var fluctuation: Fluctuation
        /** Attached pool &#x60;Pool&#x60; */
        public var attachedPool: ObjectID?
        /** **&#x60;EventKind&#x60;** What sort of event is this ?   - **Inbox**   - 0   - **Generated**  - 1  - by default   - **Planned**   - 2 - for every organized event (gala, concert, party and so on)   - **Prevention** - 4 - for prevention message from authorities, rescues parteners   - **Information**  - 8 - informative messages from authorities, rescues and staff  */
        public var kind: EventKind.RawValue
        /** Allowed user list if not null */
        public var viewers: [User.ID]?
    }
}
