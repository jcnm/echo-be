import Authentication
import Crypto
import FluentSQLite
import Vapor

/// An ephermal authentication token that identifies a registered user.
final public class UserToken: AdoptedModel {
    /// Creates a new `UserToken` for a given user.
    static public func create(userID: User.ID) throws -> UserToken {
        // generate a random 128-bit, base64-encoded string.
        let token = try CryptoRandom().generateData(count: 16).base64EncodedString()
        // init a new `UserToken` from that string.
        return .init(token: token, userID: userID)
    }
    
    /// See `Model`.
    static public var deletedAtKey: TimestampKey? { return \.expiresAt }
    
    /// UserToken's unique identifier.
    public var id: ObjectID?
    
    /// Unique token string.
    public var token: String
    
    /// Reference to user that owns this token.
    public var userID: User.ID
    
    /// Expiration date. Token will no longer be valid after this point.
    public var expiresAt: Date?
    
    /// Creates a new `UserToken`.
    public init(id: ObjectID? = nil, token: String, userID: User.ID) {
        self.id = id
        self.token = token
        // set token to expire after 48 hours
        self.expiresAt = Date.init(timeInterval: 60 * 60 * 48, since: .init())
        self.userID = userID
    }
}

public extension UserToken {
    /// Fluent relation to the user that owns this token.
    var user: Parent<UserToken, User> {
        return parent(\.userID)
    }
}

/// Allows this model to be used as a TokenAuthenticatable's token.
extension UserToken: Token {
    /// See `Token`.
    public typealias UserType = User
    
    /// See `Token`.
    public static var tokenKey: WritableKeyPath<UserToken, String> {
        return \.token
    }
    
    /// See `Token`.
    public static var userIDKey: WritableKeyPath<UserToken, User.ID> {
        return \.userID
    }
}

/// Allows `UserToken` to be used as a Fluent migration.
extension UserToken: Migration {
    /// See `Migration`.
    public static func prepare(on conn: SQLiteConnection) -> Future<Void> {
        return SQLiteDatabase.create(UserToken.self, on: conn) { builder in
            builder.field(for: \.id, isIdentifier: true)
            builder.field(for: \.token)
            builder.field(for: \.userID)
            builder.field(for: \.expiresAt)
            builder.reference(from: \.userID, to: \User.id)
        }
    }
}

/// Allows `UserToken` to be encoded to and decoded from HTTP messages.
extension UserToken: Content { }

/// Allows `UserToken` to be used as a dynamic parameter in route definitions.
extension UserToken: Parameter { }
