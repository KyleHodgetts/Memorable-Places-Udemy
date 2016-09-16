//
//  Place.swift
//  Memorable Places
//
//  Created by Kyle Hodgetts on 16/09/16.
//  Copyright © 2016 com.github.kylehodgetts. All rights reserved.
//

import Foundation
import MapKit

class Place: NSObject {
    private var _name: String!
    private var _location: CLLocationCoordinate2D!
    
    init(name: String, latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        _name = name
        _location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    var name: String {
        get{
            return _name
        }
    }
    
    var location: CLLocationCoordinate2D {
        get {
            return _location
        }
    }
}
