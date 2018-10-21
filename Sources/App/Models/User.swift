import Authentication
import FluentSQLite
import Vapor

/// A registered user, capable of owning todo items.
public final class User:  AdoptedModel {

    public static let name = "user"
    /// Can be `nil` if the object has not been saved yet.
    public var id: User.ID?
    /** Object-Access Control Level */
    public var acl: ACL
    /** Creation date */
    public var createdAt: Date
    /** Updated date */
    public var updatedAt: Date

    /** Usual login name */
    public var login: String
    /** The preferable to show user name */
    public var screenName: String?
    /** Smaller designed name of the user */
    public var shortName: String?

    /** Last login dat */
    public var lastLogin: Date?

    /** User avatar uri */
    public var avatar: AbsolutePath?

    /** Account Type using &#x60;UserKind&#x60;
     with these values:
     * 1 : **Bot**
     * 2 : **User**
     * 4 : **Aid**
     * 8 : **People**
     * 16 : **Staff**
     * 32 : **Moderator**
     * 64 : **Administrator**  */
    public var kind: UserKind.RawValue
    
    /** Channel used to sign this user &#x60;Channel&#x60;  */
    public var signupChannel: Channel.ID?
    
    /** User salted and encrypted password. */
    public var lastLocation: Location?
    
    /** Attached profile &#x60;Profile&#x60;  */
    public var profile: Profile.ID

    /// BCrypt hash of the user's password.
    public var passwordHash: String
    
    /** email **/
    public var email: String

    /// Creates a new `User`.
    public init(id: User.ID?, passwordHash: String, createdAt: Date, updatedAt: Date, acl: ACL, login: String, screenName: String, shortName: String?, avatar: AbsolutePath?, kind: UserKind.RawValue, signupChannel: ObjectID?, email: String, lastLocation: Location?, profile: Profile.ID, lastLogin: Date?) {
        
        self.passwordHash = passwordHash
        self.lastLogin = lastLogin
        self.acl = acl
        self.login = login
        self.screenName = screenName
        self.shortName = shortName
        self.avatar = avatar
        self.kind = kind
        self.signupChannel = signupChannel
        self.email = email
        self.lastLocation = lastLocation
        self.profile = profile
        self.id = id
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    public func response(_ req: Vapor.Request) -> Future<User.Response> {
        return self.details.get(on: req).map{ (prof) in
            return User.Response(id: self.id!, avatar: self.avatar, createdAt: self.createdAt, updatedAt: self.updatedAt, login: self.login, email: self.email,  screenName: self.screenName, shortName: self.shortName, lastActivity: self.lastLogin, kind: self.kind,
                                 signupChannel: self.signupChannel, lastLocation: self.lastLocation, profile: prof.response(req), acl: self.acl)
        }
    }

    public func response(_ req: Vapor.Request, with profile: Profile) -> Future<User.Response> {
        return req.future(User.Response(id: self.id!, avatar: self.avatar, createdAt: self.createdAt, updatedAt: self.updatedAt,
                             login: self.login, email: self.email,  screenName: self.screenName, shortName: self.shortName,
                             lastActivity: self.lastLogin, kind: self.kind, signupChannel: self.signupChannel,
                             lastLocation: self.lastLocation, profile: profile.response(req), acl: self.acl))
    }
}

/// Allows users to be verified by basic / password auth middleware.
extension User: PasswordAuthenticatable {
    /// See `PasswordAuthenticatable`.
    public static var usernameKey: WritableKeyPath<User, String> {
        return \.login
    }
    
    /// See `PasswordAuthenticatable`.
    public static var passwordKey: WritableKeyPath<User, String> {
        return \.passwordHash
    }
}

/// Allows users to be verified by bearer / token auth middleware.
extension User: TokenAuthenticatable { /// See `TokenAuthenticatable`.
    public typealias TokenType = UserToken
}

public extension User {
    /// Fluent relation to the user that owns this token.
    public var details: Parent<User, Profile> {
        return parent(\.profile)
    }
}


/// Allows `User` to be used as a Fluent migration.
extension User: Migration { /// See `Migration`.
    public static func prepare(on conn: SQLiteConnection) -> Future<Void> {
        return SQLiteDatabase.create(User.self, on: conn) { builder in
            builder.field(for: \.id, isIdentifier: true)
            builder.field(for: \.login )
            builder.field(for: \.email)
            builder.field(for: \.screenName)
            builder.field(for: \.shortName)
            builder.field(for: \.createdAt)
            builder.field(for: \.updatedAt)
            builder.field(for: \.lastLogin)
            builder.field(for: \.acl)
            builder.field(for: \.passwordHash)
            builder.field(for: \.kind)
            builder.field(for: \.signupChannel)
            builder.field(for: \.lastLocation)
            builder.field(for: \.profile)
            builder.field(for: \.avatar)
            builder.unique(on: \.email)
            builder.unique(on: \.login)
            builder.unique(on: \.id)
            builder.reference(from: \User.profile, to: \Profile.id, onUpdate: SQLiteForeignKeyAction.noAction, onDelete: SQLiteForeignKeyAction.setNull)
            builder.reference(from: \User.signupChannel, to: \Channel.id, onUpdate: SQLiteForeignKeyAction.noAction, onDelete: SQLiteForeignKeyAction.setNull)
        }
    }
}

/// Allows `User` to be encoded to and decoded from HTTP messages.
extension User: Content { }

/// Allows `User` to be used as a dynamic parameter in route definitions.
extension User: Parameter { }



// MARK: Content
public extension User {
    /// Perform HTTP request on this user
    public struct Request: Content {
    /// Data required to create a user.
        public struct Create: Content {
            /// User's login name.
            public var login: String
            /// User's given    name.
            public var givenName: String
            /// User's family name.
            public var familyName: String
            /// User's email address.
            public var email: String
            /// User's desired password.
            public var password: String
            /// User's password repeated to ensure they typed it correctly.
            public var verifyPassword: String
        }
        
        public struct UpdatePassword: Content {
            public var id: User.ID
            /// User's old password.
            public var oldPassword: String
            /// User's desired new password.
            public var password: String
            /// User's password repeated to ensure they typed it correctly.
            public var verifyPassword: String
        }
        
        /// Public common representation update of user data.
        public struct Update: Content {
            public var id: User.ID
            public var screenName: String?
            public var shortName: String?
            public var password: String?
            public var avatar: File?
        }
    }
    
    /// Public representation of user data.
    struct Response: Content {
        /// User's unique identifier. Not optional since we only return users that exist in the DB.
        public var id: User.ID
        /** User avatar uri */
        public var avatar: AbsolutePath?
        public var createdAt: Date
        /** Updated date */
        public var updatedAt: Date
        /// User's login name.
        public var login: String
        /// User's email address.
        public var email: String
        public var screenName: String?
        /** Smaller designed name of the user */
        public var shortName: String?
        
        /** Last login dat */
        public var lastActivity: Date?
        

        /** Account Type using &#x60;UserKind&#x60;
         with these values:
         * 1 : **Bot**
         * 2 : **User**
         * 4 : **Aid**
         * 8 : **People**
         * 16 : **Staff**
         * 32 : **Moderator**
         * 64 : **Administrator**  */
        public var kind: UserKind.RawValue
        
        /** Channel used to sign this user &#x60;Channel&#x60;  */
        public var signupChannel: Channel.ID?
        
        /** User salted and encrypted password. */
        public var lastLocation: Location?
        
        /** Attached profile &#x60;Profile&#x60;  */
        public var profile: Profile.Response
        public var acl: ACL
    }
}
