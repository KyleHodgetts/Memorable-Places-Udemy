//
//  MapViewController.swift
//  Memorable Places
//
//  Created by Kyle Hodgetts on 16/09/16.
//  Copyright © 2016 com.github.kylehodgetts. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    
    // Zoom level: Number of degrees difference along latitude and longitude of map
    let latDelta: CLLocationDegrees = 0.01
    let lonDelta: CLLocationDegrees = 0.01
    
    var activePlace: Place? // Will be current location if nil

    @IBOutlet weak var map: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        map.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()

        if let ap = activePlace {
            updateMap(activePlace: ap)
        }
        else {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations[0]
        
        let latitude = userLocation.coordinate.latitude
        let longitude = userLocation.coordinate.longitude
        var placeName = ""
        
        CLGeocoder().reverseGeocodeLocation(userLocation) { (placemarks, error) in
            if error != nil {
                print("ERROR IN GEOCODER \(error)")
            }
            else {
                let placemark = placemarks?[0]
                
                if let streetNum = placemark?.subThoroughfare {
                    placeName += streetNum
                }
                
                if let streetName = placemark?.thoroughfare {
                    placeName += "\(streetName)"
                }
                
                self.activePlace = Place(name: placeName, latitude: latitude, longitude: longitude)
                self.updateMap(activePlace: self.activePlace!)
            }
        }
    
    }
    
    private func updateMap(activePlace: Place) {
        let span: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
        let region: MKCoordinateRegion = MKCoordinateRegion(center: activePlace.location, span: span)
        map.setRegion(region, animated: true)
        let userLocation = map.userLocation
        userLocation.title = "You"
        map.addAnnotation(userLocation)
    }
}
