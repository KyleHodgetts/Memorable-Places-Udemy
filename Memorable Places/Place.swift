//
//  Place.swift
//  Memorable Places
//
//  Created by Kyle Hodgetts on 16/09/16.
//  Copyright © 2016 com.github.kylehodgetts. All rights reserved.
//

import Foundation
import MapKit

@objc(Place)
class Place: NSObject, NSCoding {
    private var _name: String!
    private var _note: String?
    private var _location: CLLocationCoordinate2D!
    
    init(name: String, note: String?, latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        _name = name
        _note = note
        _location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    // MARK: NSCoding
    
    convenience required init(coder decoder: NSCoder) {
        let name = decoder.decodeObject(forKey: "name") as? String
        let note = decoder.decodeObject(forKey: "note") as? String
        let lat = decoder.decodeDouble(forKey: "latitude") as Double
        let long = decoder.decodeDouble(forKey: "longitude") as Double
        
        self.init(name: name!, note: note, latitude: lat, longitude: long)
    }
    
    func encode(with aCoder: NSCoder){
        aCoder.encode(self._name, forKey: "name")
        aCoder.encode(self._note, forKey: "note")
        aCoder.encode(self._location.latitude, forKey: "latitude")
        aCoder.encode(self._location.longitude, forKey: "longitude")
    }
    
    var name: String {
        get{
            return _name
        }
    }
    
    var note: String? {
        if let n = _note {
            return n
        }
        return nil
    }
    
    var location: CLLocationCoordinate2D {
        get {
            return _location
        }
    }
}
