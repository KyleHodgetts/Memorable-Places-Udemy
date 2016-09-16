//
//  MapViewController.swift
//  Memorable Places
//
//  Created by Kyle Hodgetts on 16/09/16.
//  Copyright © 2016 com.github.kylehodgetts. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    // Zoom level: Number of degrees difference along latitude and longitude of map
    let latDelta: CLLocationDegrees = 0.01
    let lonDelta: CLLocationDegrees = 0.01
    
    var activePlace: Place? // Will be current location if nil

    @IBOutlet weak var map: MKMapView!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if activePlace == nil {
            // Set to current users location
        }
        
        let latitude: CLLocationDegrees = 52.231876
        let longitude: CLLocationDegrees = 21.005798
        
        let span: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
        
        let location: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        let region: MKCoordinateRegion = MKCoordinateRegion(center: location, span: span)
        map.setRegion(region, animated: true)
        
        map.delegate = self
    }
}

