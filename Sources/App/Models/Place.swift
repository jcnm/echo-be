//
//  Place.swift
//  App
//
//  Created by J. Charles N. M. on 16/09/2018.
//
import Authentication
import FluentSQLite
import Vapor
//// TODO: Uniformising createdAt to createdAt or createdOn

public final class Place: AdoptedModel, Equatable {
    public static func == (lhs: Place, rhs: Place) -> Bool {
        return lhs.id == rhs.id
    }
    public static let name = "place"
    /// Can be `nil` if the object has not been saved yet.
    public var id: Place.ID?
    /** Object-Access Control Level */
    public var acl: ACL
    /** Creation date */
    public var createdAt: Date
    /** Updated date */
    public var updatedAt: Date
    /// Place given title usefull for uniq places
    public var title: String?
    public var container: Place.ID?
    /// Place given name usefull for named street
    public var noun: String
    
    /** Short designed name of this place, could be used to indicate that California could be replaced by CA or France by FR when the place state for California or France. */
    public var acronym: String?
    /** Type of place (TODO: transform to UInt)  - *House* - *Street* - *Alley* - *Place* - *Avenue*  - *Boulevard* - *Road*  - *NBHood* - *Town* - *City* - *State*  - *Country* - *Continent*  - *Ocean*   */
    public var kind: PlaceKind.RawValue
    /** The street, place number / id index if needed */
    public var number: Int?
    /** Used to indicate for example : for street, the street number, for country, the iso number, for region the ZipCode */
    public var postalCode: String?
    /** Main locations of  this place, at least one location is required if bounding field is missing. */
    public var coordinates: [Location]?
    /** Place position into the Earth map */
    public var bounding: ObjectID?
    /** Main emails to contact for this place */
    public var emails: [NamedEmail]?
    /** Main Uris to reach for more information about this place */
    public var uris: [NamedURI]?
    /** Main phone number to contact for this place */
    public var phones: [StringTuple]?
    /** Usefull to indicate if the street number is the &lt;number&gt;bis, &lt;number&gt;ter etc... */
    public var afterNumber: String?
    /**   */
    public var afterName: String?
    /** Complementary details */
    public var complement: [StringTuple]?
    
    public init(id: Place.ID?, noun: String, title: String?, createdAt: Date, updatedAt: Date, container: Place.ID?, acronym: String?, kind: PlaceKind.RawValue, number: Int?, postalCode: String?, coordinates: [Location]?, bounding: ObjectID?, emails: [NamedEmail]?, uris: [NamedURI]?, phones: [StringTuple]?, afterNumber: String?, afterName: String?, complement: [StringTuple]?, acl: ACL) {
        self.title      = title
        self.noun       = noun
        self.acl        = acl
        self.container  = container
        self.acronym    = acronym
        self.kind       = kind
        self.number     = number
        self.postalCode = postalCode
        self.coordinates = coordinates
        self.bounding   = bounding
        self.emails     = emails
        self.uris       = uris
        self.phones     = phones
        self.afterNumber = afterNumber
        self.afterName  = afterName
        self.complement = complement
        self.id         = id
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    
    public func response(_ req: Vapor.Request) -> Future<Place.Response> {
        return
            req.future(
                Place.Response(id: self.id!, noun: self.noun, title: self.title, container: self.container, acl: self.acl, createdAt: self.createdAt,
                               updatedAt: self.updatedAt, acronym: self.acronym, kind: self.kind, number: self.number, postalCode: self.postalCode,
                               coordinates: self.coordinates, bounding: self.bounding, emails: self.emails, uris: self.uris, phones: self.phones,
                               complement: self.complement, afterNumber: self.afterNumber, afterName: self.afterName))
    }

}

extension Place {
    /// Fluent relation to the user that owns this token.
//    var place: Parent<Place, Place> {
//        return parent(\.container)
//    }
}


/// Allows `Profile` to be used as a Fluent migration.
extension Place: Migration { /// See `Migration`.
    public static func prepare(on conn: SQLiteConnection) -> Future<Void> {
        return SQLiteDatabase.create(Place.self, on: conn) { builder in
            builder.field(for: \.id, isIdentifier: true)
            builder.field(for: \.title )
            builder.field(for: \.noun )
            builder.field(for: \.container)
            builder.field(for: \.acronym)
            builder.field(for: \.kind)
            builder.field(for: \.number)
            builder.field(for: \.postalCode)
            builder.field(for: \.coordinates)
            builder.field(for: \.bounding)
            builder.field(for: \.emails)
            builder.field(for: \.uris)
            builder.field(for: \.phones)
            builder.field(for: \.afterNumber)
            builder.field(for: \.afterName)
            builder.field(for: \.complement)
            builder.reference(from: \Place.container, to: \Place.id)
            builder.unique(on: \.id)
        }
    }
}

/// Allows `Profile` to be encoded to and decoded from HTTP messages.
extension Place: Content { }

/// Allows `Profile` to be used as a dynamic parameter in route definitions.
extension Place: Parameter { }

// MARK: Content
extension Place {
    /// Data required to create a user.
    struct Request: Content {
        
        public struct Create: Content {
            public var noun: String
            public var title: String?
            public var container: Place.ID?
            /** Object-Access Control Level */
            public var acl: ACL
            /** Short designed name of this place, could be used to indicate that California could be replaced by CA or France by FR when the place state for California or France. */
            public var acronym: String?
            /** Type of place (TODO: transform to UInt)  - *House* - *Street* - *Alley* - *Place* - *Avenue*  - *Boulevard* - *Road*  - *NBHood* - *Town* - *City* - *State*  - *Country* - *Continent*  - *Ocean*   */
            public var kind: PlaceKind.RawValue
            /** The street, place number / id index if needed */
            public var number: Int?
            /** Used to indicate for example : for street, the street number, for country, the iso number, for region the ZipCode */
            public var postalCode: String?
            /** Main locations of  this place, at least one location is required if bounding field is missing. */
            public var coordinates: [Location]?
            /** Usefull to indicate if the street number is the &lt;number&gt;bis, &lt;number&gt;ter etc... */
            public var afterNumber: String?
            /**   */
            public var afterName: String?
            /** Main emails to contact for this place */
            public var emails: [NamedEmail]?
            /** Main Uris to reach for more information about this place */
            public var uris: [NamedURI]?
            /** Main phone number to contact for this place */
            public var phones: [StringTuple]?
            /** Complementary details */
            public var complement: [StringTuple]?
        }
        
        public struct Update: Content {
            public var id: Place.ID
            public var noun: String
            public var title: String?
            public var container: Place.ID?
            /** Object-Access Control Level */
            public var acl: ACL
            /** Short designed name of this place, could be used to indicate that California could be replaced by CA or France by FR when the place state for California or France. */
            public var acronym: String?
            /** Type of place (TODO: transform to UInt)  - *House* - *Street* - *Alley* - *Place* - *Avenue*  - *Boulevard* - *Road*  - *NBHood* - *Town* - *City* - *State*  - *Country* - *Continent*  - *Ocean*   */
            public var kind: PlaceKind.RawValue
            /** The street, place number / id index if needed */
            public var number: Int?
            /** Used to indicate for example : for street, the street number, for country, the iso number, for region the ZipCode */
            public var postalCode: String?
            /** Main locations of  this place, at least one location is required if bounding field is missing. */
            public var coordinates: [Location]?
            /** Place position into the Earth map */
            public var bounding: ObjectID?
            /** Main emails to contact for this place */
            public var emails: [NamedEmail]?
            /** Main Uris to reach for more information about this place */
            public var uris: [NamedURI]?
            /** Main phone number to contact for this place */
            public var phones: [StringTuple]?
            /** Complementary details */
            public var complement: [StringTuple]?
            /** Usefull to indicate if the street number is the &lt;number&gt;bis, &lt;number&gt;ter etc... */
            public var afterNumber: String?
            /**   */
            public var afterName: String?
        }
    }
    
    /// Public representation of user data.
    public struct Response: Content {
        public var id: Place.ID
        public var noun: String
        public var title: String?
        public var container: Place.ID?
        /** Object-Access Control Level */
        public var acl: ACL
        /** Creation date */
        public var createdAt: Date
        /** Updated date */
        public var updatedAt: Date
      /** Short designed name of this place, could be used to indicate that California could be replaced by CA or France by FR when the place state for California or France. */
        public var acronym: String?
        /** Type of place (TODO: transform to UInt)  - *House* - *Street* - *Alley* - *Place* - *Avenue*  - *Boulevard* - *Road*  - *NBHood* - *Town* - *City* - *State*  - *Country* - *Continent*  - *Ocean*   */
        public var kind: PlaceKind.RawValue
        /** The street, place number / id index if needed */
        public var number: Int?
        /** Used to indicate for example : for street, the street number, for country, the iso number, for region the ZipCode */
        public var postalCode: String?
        /** Main locations of  this place, at least one location is required if bounding field is missing. */
        public var coordinates: [Location]?
        /** Place position into the Earth map */
        public var bounding: ObjectID?
        /** Main emails to contact for this place */
        public var emails: [NamedEmail]?
        /** Main Uris to reach for more information about this place */
        public var uris: [NamedURI]?
        /** Main phone number to contact for this place */
        public var phones: [StringTuple]?
        /** Complementary details */
        public var complement: [StringTuple]?
        /** Usefull to indicate if the street number is the &lt;number&gt;bis, &lt;number&gt;ter etc... */
        public var afterNumber: String?
        /**   */
        public var afterName: String?
    }
    
}

