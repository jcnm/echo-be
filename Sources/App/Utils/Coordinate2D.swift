//
//  Coordinate2D.swift
//  App
//
//  Created by J. Charles N. M. on 23/09/2018.
//

import Foundation
/// From GeoSwift 2016 Petr Pavlik (https://twitter.com/ptrpavlik)
/// https://github.com/petrpavlik/GeoSwift/blob/master/Sources/GeoSwift.swift
/// `GeoCoordinate2DError` is the error type thrown by GeoCoordinate2D in case of an attempt to create an instance with invalid coordinates.
///
/// - invalidLatitude: Provided latitude is outside of acceptable bounds abs(latitude) <= 90.
/// - invalidLongitude: Provided longitude is outside of acceptable bounds abs(latitude) <= 180.
public enum Coordinate2DError: Error {
    case invalidLatitude
    case invalidLongitude
    case invalideCoordinate
}

/// Represents a valid location coordinate. Initializer throws `GeoCoordinate2DError` error in case of an attempt to create an instance with invalid coordinates.
public struct Coordinate2D {
    public let latitude: Double
    public let longitude: Double
    
    public init(latitude: Double, longitude: Double) throws {
        
        guard abs(latitude) <= 90 else {
            throw Coordinate2DError.invalidLatitude
        }
        
        guard abs(longitude) <= 180 else {
            throw Coordinate2DError.invalidLongitude
        }
        
        self.latitude = latitude
        self.longitude = longitude
    }
    
    public init(coordinate2D: [Double]) throws {
        try self.init(latitude: coordinate2D[0], longitude: coordinate2D[1])
    }
    
    public func array() -> Location {
        return [self.latitude, self.longitude]
    }
    
}

public extension Coordinate2D {
    
    /// Returns distance from provided `GeoCoordinate2D` instance in meters using Haversine formula.
    public func distance(from: Coordinate2D) -> Double {
        
        // Algorithm shamelessly copied from http://www.movable-type.co.uk/scripts/latlong.html
        let R = 6371e3; // metres
        let φ1 = latitude * Double.pi / 180
        let φ2 = from.latitude * Double.pi / 180
        let Δφ = (from.latitude-latitude) * Double.pi / 180
        let Δλ = (from.longitude-longitude) * Double.pi / 180
        
        // Broken into 2 expressions to avoid 'expression too complex' error on linux
        var a = sin(Δφ/2) * sin(Δφ/2)
        a += cos(φ1) * cos(φ2) * sin(Δλ/2) * sin(Δλ/2)
        
        let c = 2 * atan2(sqrt(a), sqrt(1-a));
        
        return R * c;
    }
    
    public func perimeter(radius: Double, in locations: [Location]) throws -> [Location] {
        var found: [Location] = []
        for e in locations {
            if distance(from: try Coordinate2D(coordinate2D: e)) <= radius {
                found.append(e)
            }
        }
        return found
    }
    
    public func perimeter(radius: Double, in coordinate: [Coordinate2D]) -> [Coordinate2D] {
        var found: [Coordinate2D] = []
        for e in coordinate {
            if distance(from: e) <= radius {
                found.append(e)
            }
        }
        return found
    }
    
    public func perimeter(radius: Double, in coordinate: [Coordinate2D]) -> [Location] {
        var found: [Location] = []
        for e in coordinate {
            if distance(from: e) <= radius {
                found.append(e.array())
            }
        }
        return found
    }

}
