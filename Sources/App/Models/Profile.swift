//
//  Profile.swift
//  App
//
//  Created by J. Charles N. M. on 16/09/2018.
//


import Authentication
import FluentSQLite
import Vapor

public final class Profile: AdoptedModel {
    /// Can be `nil` if the object has not been saved yet.
    public var id: Profile.ID?
    /** The attached user &#x60;User&#x60; */
    public var attachedTo: ObjectID?
    /** User&#39;s name suffix */
    public var namePrefix: String?
    /** User&#39;s first name */
    public var givenName: String
    /** User&#39;s middle name */
    public var middleName: String?
    /** User&#39;s last name */
    public var familyName: String
    /** User&#39;s name suffix */
    public var nameSuffix: String?
    /** User&#39;s middle name */
    public var birthday: Date?
    /** User&#39;s secondary email. Not set int the emails field since the element order in that array is not defined. */
    public var backupEmail: String?
    /** Addresses attached to this profile */
    public var places: [Place.ID]?
    /** Main emails to contact for this place */
    public var emails: [NamedEmail]?
    /** Main Uris to reach for more information about this place */
    public var uris: [NamedURI]?    
    
    
    public init(id: Profile.ID?, attachedTo: ObjectID?, namePrefix: String?, givenName: String, middleName: String?, familyName: String, nameSuffix: String?, birthday: Date?, backupEmail: String?, places: [Place.ID]?, emails: [NamedEmail]?, uris: [NamedURI]?) {
        self.id = id
        self.attachedTo = attachedTo
        self.namePrefix = namePrefix
        self.givenName = givenName
        self.middleName = middleName
        self.familyName = familyName
        self.nameSuffix = nameSuffix
        self.birthday = birthday
        self.backupEmail = backupEmail
        self.places = places
        self.emails = emails
        self.uris = uris
    }
    
    public func response(_ on: Vapor.Request) -> Profile.Response {
        return Response(id: self.id!, namePrefix: self.namePrefix, givenName: self.givenName, middleName: self.middleName, familyName: self.familyName, nameSuffix: self.nameSuffix, birthday: self.birthday, backupEmail: self.backupEmail, places: self.places, emails: self.emails, uris: self.uris)
    }
}

public extension Profile {
    /// Fluent relation to the user that owns this token.
}


/// Allows `Profile` to be used as a Fluent migration.
extension Profile: Migration { /// See `Migration`.
    public static func prepare(on conn: SQLiteConnection) -> Future<Void> {
        return SQLiteDatabase.create(Profile.self, on: conn) { builder in
            builder.field(for: \.id, isIdentifier: true)
            builder.field(for: \.attachedTo )
            builder.field(for: \.namePrefix)
            builder.field(for: \.givenName)
            builder.field(for: \.middleName)
            builder.field(for: \.familyName)
            builder.field(for: \.nameSuffix)
            builder.field(for: \.birthday)
            builder.field(for: \.backupEmail)
            builder.field(for: \.places)
            builder.field(for: \.emails)
            builder.field(for: \.uris)
            builder.unique(on: \.id)
        }
    }
}

/// Allows `Profile` to be encoded to and decoded from HTTP messages.
extension Profile: Content { }

/// Allows `Profile` to be used as a dynamic parameter in route definitions.
extension Profile: Parameter { }

// MARK: Content
public extension Profile {
    
    /// Data required to create and update a profile.
    public struct Request: Content {
        public struct Create: Content {
            /** The attached user &#x60;User&#x60; */
            public var attachedUser: User.ID
            /** User&#39;s name suffix */
            public var namePrefix: String?
            /** User&#39;s first name */
            public var givenName: String
            /** User&#39;s middle name */
            public var middleName: String?
            /** User&#39;s last name */
            public var familyName: String
            /** User&#39;s name suffix */
            public var nameSuffix: String?
            /** User&#39;s middle name */
            public var birthday: Date?
            /** User&#39;s secondary email. Not set int the emails field since the element order in that array is not defined. */
            public var backupEmail: String?
        }
        
        public struct Update: Content {
            /// Can be `nil` if the object has not been saved yet.
            public var id: Profile.ID
            /** The attached user &#x60;User&#x60; */
            public var attachedUser: User.ID
            /** User&#39;s name suffix */
            public var namePrefix: String?
            /** User&#39;s first name */
            public var givenName: String
            /** User&#39;s middle name */
            public var middleName: String?
            /** User&#39;s last name */
            public var familyName: String
            /** User&#39;s name suffix */
            public var nameSuffix: String?
            /** User&#39;s middle name */
            public var birthday: Date?
            /** User&#39;s secondary email. Not set int the emails field since the element order in that array is not defined. */
            public var backupEmail: String?
            /** Addresses attached to this profile */
            public var places: [Place.ID]?
            /** Main emails to contact for this place */
            public var emails: [NamedEmail]?
            /** Main Uris to reach for more information about this place */
            public var uris: [NamedURI]?
        }
    }
    
    /// Public representation of profil data.
    public struct Response: Content {
        public var id: Profile.ID
        /** The attached user &#x60;User&#x60; */
//        public var attachedUser: User.ID
        /** User&#39;s name suffix */
        public var namePrefix: String?
        /** User&#39;s first name */
        public var givenName: String
        /** User&#39;s middle name */
        public var middleName: String?
        /** User&#39;s last name */
        public var familyName: String
        /** User&#39;s name suffix */
        public var nameSuffix: String?
        /** User&#39;s middle name */
        public var birthday: Date?
        /** User&#39;s secondary email. Not set int the emails field since the element order in that array is not defined. */
        public var backupEmail: String?
        /** Addresses attached to this profile */
        public var places: [Place.ID]?
        /** Main emails to contact for this place */
        public var emails: [NamedEmail]?
        /** Main Uris to reach for more information about this place */
        public var uris: [NamedURI]?
    }
}

