//
//  Extra.swift
//  App
//
//  Created by J. Charles N. M. on 16/09/2018.
//

import Foundation
import Crypto
import FluentSQLite
import Vapor

public typealias Fluctuation    = Double // from (low/negative impact) *-1* - *0* - *+1* (high impact)
public typealias ObjectID       = Int
public typealias AdoptedModel   = SQLiteModel
public typealias AdoptedPivot   = SQLitePivot
public typealias AbsolutePath   = String

public typealias Tuple<F, S>    = (F, S)
//public typealias StringTuple    = Tuple<String, String> // Not yet exportable to objc and not codable decodable
public typealias StringTuple    = NamedValue<String> // With exactely 2 elements
public typealias NamedEmail     = NamedValue<String>
public typealias NamedURI       = StringTuple
public typealias NamedPlace       = NamedValue<Place.ID>

/** Channel type  *
 0 : **Developer** channel *
 1 : **Partner** channel *
 2 : **Rescue** *
 4 : **Authority** *
 8 : **Official** echo channel */
public enum ChannelKind: Int, Codable {
    case developer   = 1 //
    case partener = 2 //
    case authority  = 4 //
    case official  = 8 //
}


/**
 *
 ObjectStatus defines object status of a given object.

 Stash - 0 - Object is not yet evaluated
 Online - 1 - By default
 Offline - 2
 Rejected - 4 -
 Signaled - 8
 Await - 16 - when assigned for review
 Review - 32*/
public enum ObjectStatus: Int, Codable {
    case stash      = 0 // Object is submetted but not yet evaluated
    case online     = 1 // default - pushed online
    case offline    = 2
    case rejected   = 4
    case signaled   = 8
    case await      = 16
    case review     = 32
    
    public static func has(value: Int, status: ObjectStatus) -> Bool {
        let res = value & status.rawValue
        return res == status.rawValue
    }
    
    public func into(value: Int) -> Bool {
        let res = value & self.rawValue
        return res == self.rawValue
    }
}

/**
 AccessRight defines access right to a given echo.
 
 None - 0 - No right on this (only accessible by the owner)
 Read - 1 - Readable by the defined visibility users
 Write - 2 - targeted users can response to this
 Search - 4 - can appear on research
 Share - 8 - Targeted users can share this*/

public enum AccessRight: Int, Codable {
    case owner  = 0 // Only accessible by the owner
    case read   = 1 // Readable by the defined visibility users
    case write  = 2 // targeted users can response to this
    case search = 4 // can appear on research
    case share  = 8 // targeted users can share this
}

/**
 *
 VisibilityPolicy defines visibility policy of a a given object.
 
 Private - 0 - No right to the given echo except if a given authorized list is not empty, set the object as hidden on search engine
 Enclosed - 1 - Visible to enclosed people
 Related - 2 - Visiblle only to my relations
 Opened - 4 - Searchable and access on requests if permited by the accessRight
 Public - 8 - Visible by every one and exposable if permited by the accessRight
 default: 8
 maximum: 16
 */
public enum VisibilityPolicy: Int, Codable {
    case `private`  = 0 // No right to the given echo except if a given authorized list is not empty, set the object as hidden on search engine
    case enclose   = 1 // Visible to enclosed people (near the data)
    case relate  = 2 // Visiblle only to my relations
    case open = 4 // Searchable and access on requests if permited by the accessRight
    case visible  = 8 // -by default - Visible by every one and exposable if permited by the accessRight
}


public enum RippleKind : Int, Codable {
    case passive = 1, active = 2 , semiActive = 4
}

/** Given witness score
 * 4 :**Present** I was there
 * 2 : **Truth** this real not hoax
 * 1 : **Maybe** to confirm
 * 0 : **Fake**  this an hoax  A given event!echo with too many witness designing it as fake will be deleted in long term (long term means a week or less). */

public enum WitnessScore: Int, Codable {
    case present    = 4 // I was there
    case truth      = 2 // this real not hoax
    case maybe      = 1 // to confirm
    case fake       = 0 // this an hoax. A given event/echo with too many witness designing it as fake will be deleted in long term (long term means a week or less)
}

/** **&#x60;EventKind&#x60;** What sort of event is this ?
 - **Inbox**   - 0
 - **Generated**  - 1  - by default
 - **Planned**   - 2 - for every organized event (gala, concert, party and so on)
 - **Prevention** - 4 - for prevention message from authorities, rescues parteners
 - **Information**  - 8 - informative messages from authorities, rescues and staff  */
public enum EventKind : Int, Codable {
    case inbox = 0
    case generated = 1 // by default
    case planned  = 2 //for every organized event (gala, concert, party and so on)
    case prevention = 4 // for prevention message from authorities, rescues parteners
    case information = 8 // informative messages from authorities, rescues and staff
}

public struct NamedValue<V: Codable> : Codable {
    public var name: String
    public var value: V
    public init(name: String, value: V) {
        self.name = name
        self.value = value
    }
}

// Relfextion for named value with string
extension NamedValue: ReflectionDecodable, AnyReflectionDecodable where  V == String {
    public static func reflectDecoded() throws -> (NamedValue<V>, NamedValue<V>) {
        return (NamedValue<String>(name: "name", value: "value"), NamedValue<String>(name: "value", value: "name"))
    }
    
    public static func reflectDecodedIsLeft(_ item: NamedValue<V>) throws -> Bool {
        return item.name == "name" && item.value == "value"
    }
    
}

//// Relfextion for named value with string and int
//extension NamedValue: ReflectionDecodable, AnyReflectionDecodable where V == Int {
//    public static func reflectDecoded() throws -> (NamedValue<V>, NamedValue<V>) {
//        return (NamedValue<Int>(name: "name", value: 1), NamedValue<Int>(name: "value", value: 0))
//    }
//
//    public static func reflectDecodedIsLeft(_ item: NamedValue<V>) throws -> Bool {
//        return item.name == "name" && item.value == 1
//    }
//}

public struct ACL: Codable, ReflectionDecodable {
    public static func reflectDecoded() throws -> (ACL, ACL) {
        return (ACL(), ACL(status: ObjectStatus.offline.rawValue, visibility: VisibilityPolicy.private.rawValue, right: AccessRight.share.rawValue, viewers: []))
    }
    
    public static func reflectDecodedIsLeft(_ item: ACL) throws -> Bool {
        return item.status == ObjectStatus.online.rawValue
    }
    
    public var status: Int
    public var visibility: Int
    public var right: Int
    public var viewers: [User.ID]?
    
    init(status: Int, visibility: Int, right: Int, viewers: [User.ID]?) {
        self.status     = status
        self.visibility = visibility
        self.right      = right
        self.viewers = viewers
    }
    
    init() {
        status      = ObjectStatus.online.rawValue
        visibility  = VisibilityPolicy.visible.rawValue
        right       = AccessRight.share.rawValue
            | AccessRight.read.rawValue
            | AccessRight.write.rawValue
            | AccessRight.search.rawValue
    }
}

public struct Device: Codable, ReflectionDecodable {
    public static func reflectDecoded() throws -> (Device, Device) {
        return (Device(deviceName: "Unknow", deviceBrand: "NoBrand", deviceVersion: "Alpha", deviceKind: .mobile, deviceLocale: "N/A", systemVersion: nil, systemName: "n/a"),
        Device(deviceName: "", deviceBrand: String(), deviceVersion: String(), deviceKind: .desktop, deviceLocale: String(), systemVersion: "n/a", systemName: nil))
    }
    
    public static func reflectDecodedIsLeft(_ item: Device) throws -> Bool {
        return item.deviceKind == .mobile && item.systemVersion == nil
    }
    
    public var deviceName: String
    public var deviceBrand: String
    public var deviceVersion: String
    public var deviceKind: DeviceKind
    /** Locale field provide the user system language */
    public var deviceLocale: String
    /** Operating system version,  *&lt;VERSION_ID&gt;*|*&lt;BUILD&gt;* */
    public var systemVersion: String?
    /** Operating system name (i.e *Windows*, *Debian*, *OS X*, *iOS*, etc.) */
    public var systemName: String?
    
    public enum DeviceKind : String, Codable, ReflectionDecodable {
        public static func reflectDecoded() throws -> (Device.DeviceKind, Device.DeviceKind) {
            return (.mobile, .browser)
        }
        case mobile, browser, desktop
    }
}

/** Account Type using &#x60;UserKind&#x60;
 with these values:
 * 1 : **Bot**
 * 2 : **User**
 * 4 : **Aid**
 * 8 : **People**
 * 16 : **Staff**
 * 32 : **Moderator**
 * 64 : **Administrator**  */

public enum UserKind: Int, Codable {
    case bot    = 1
    case user   = 2
    case aid    = 4
    case people = 8
    case staff  = 16
    case modo   = 32
    case admin  = 64
}

/**
 1 - Text for message post (by default)
 2 - Image
 4 - URI
 8 - Sound
 10 - Video as an image and sound data
 15 - Document as a full mix of the others
 */
public enum MediaKind: Int, Codable {
    case text   = 1
    case uri    = 2
    case image  = 4
    case sound  = 8
    case video  = 12
    case doc    = 15
    
}

/** Formal Relation type &#x60;UserRelationKind&#x60;  -
 0 : **Knowledge** -
 1 : **OldFriend** -
 2 : **Friend** -
 4 : **CloseFriend** -
 8 : **Workmate** -
 16 : **Roommate** -
 32: **Family** */

public enum RelationKind: Int, Codable {
    case knowledge  = 0
    case oldFriend  = 1
    case friend     = 2
    case closeFrind = 4
    case workmate   = 8
    case roomate    = 16
    case family     = 32
}

/**
 House
 Street
 Alley
 Place
 Avenue
 Boulevard
 Road
 NBHood
 Town
 City
 State
 Country
 Continent
 Ocean
 */
public enum PlaceKind: Int, Codable {
    case house
    case street
    case alley
    case villa
    case place
    case forest
    case domaine
    case monument
    case avenue
    case boulevard
    case road
    case nbhood
    case town
    case city
    case country
    case continent
    case ocean
}

/**
 1 : Text only
 2 : Object exchange (i.e image, sound)
 2: Audio call
 4: Video call
 */
public enum MonitorConnection: Int, Codable, ReflectionDecodable {
    public static func reflectDecoded() throws -> (MonitorConnection, MonitorConnection) {
        return (.text, .mvideo)
    }
    
    case text   = 1 // only
    case object = 2 //  exchange (i.e image, sound)
    case audio  = 4 // multicast audio streaming
    case video  = 8 // multicast video streaming
    case maudio = 16 // distributed cast audio streaming
    case mvideo = 32 // distributed cast video streaming
}
/**
 *
 1: User monitoring
 2: Partener monitoring
 4: Social monitoring
 8: Government Authority monitoring
 16: Staff monitoring*/
public enum MonitorAuthority: Int, Codable {
    case user   = 1 //
    case partener = 2 //
    case social  = 4 //
    case gov  = 8 //
    case staff = 16 //
}

public class TrackedObject {
    /// Can be `nil` if the object has not been saved yet.
    public var id: ObjectID?
    /** Creation date */
    public var createdAt: Date = Date()
}

public class EditableObject: TrackedObject {
    /** Updated date */
    public var updatedAt: Date = Date()
}

public protocol PublishableObject {
    /** Object-Access Control Level */
    var acl: ACL {get set}
}
