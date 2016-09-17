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
    var latDelta: CLLocationDegrees = 0.01
    var lonDelta: CLLocationDegrees = 0.01
    
    var activePlace: Place? // Will be current location if nil

    @IBOutlet weak var map: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let initialSpan: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
        map.region.span = initialSpan
        map.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        let longPressGestureRecogniser = UILongPressGestureRecognizer(target: self, action: #selector(MapViewController.longPress(gestureRecogniser:)))
        
        longPressGestureRecogniser.minimumPressDuration = 2
        map.addGestureRecognizer(longPressGestureRecogniser)

        if let ap = activePlace {
            updateMap(activePlace: ap)
        }
        else {
            locationManager.startUpdatingLocation()
        }
    }
    
    @IBAction func findMeTapped(_ sender: UIBarButtonItem) {
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations[0]
        CLGeocoder().reverseGeocodeLocation(userLocation, completionHandler: { (placemarks, error) in
            if error != nil {
                print("ERROR IN GEOCODER \(error)")
            }
            else {
                if let placeMark = placemarks?[0] {
                    let placeName = self.getAddressFromPlaceMark(placeMark: placeMark)
                    let lat = userLocation.coordinate.latitude
                    let long = userLocation.coordinate.longitude
                    self.activePlace = Place(name: placeName, note: nil, latitude: lat, longitude: long)
                    self.updateMap(activePlace: self.activePlace!)
                }
            }
        })
    }
    
    func longPress(gestureRecogniser: UIGestureRecognizer) {
        let touchPoint = gestureRecogniser.location(in: self.map)
        let coordinate = map.convert(touchPoint, toCoordinateFrom: self.map)
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
            if error != nil {
                print("ERROR IN GEOCODER \(error)")
            }
            else {
                if let placeMark = placemarks?[0] {
                    let placeName = self.getAddressFromPlaceMark(placeMark: placeMark)
                    self.addAnnotation(placeName: placeName, coordinate: coordinate)
                }
            }
        })
    }
    
    private func getAddressFromPlaceMark(placeMark: CLPlacemark) -> String {
        var placeName = ""
        if let streetNum = placeMark.subThoroughfare {
            placeName += streetNum
        }
        
        if let streetName = placeMark.thoroughfare {
            placeName += " \(streetName)"
        }
        
        return placeName
    }
    
    private func addAnnotation(placeName: String, coordinate: CLLocationCoordinate2D) {
        
        let alert = UIAlertController(title: "New memorable place", message: "Add a note for this memorable place", preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: nil)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
            let textField = alert.textFields![0] // Force unwrapping because we know it exists.
            let note = textField.text!
            
            self.activePlace = Place(name: placeName, note: note, latitude: coordinate.latitude, longitude: coordinate.longitude)
            
            let annotation  = MKPointAnnotation()
            annotation.coordinate = self.activePlace!.location
            annotation.title = self.activePlace?.name
            annotation.subtitle = self.activePlace!.note
            
            self.map.addAnnotation(annotation)
            self.savePlace(place: self.activePlace!)
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    private func savePlace(place: Place) {
        var places: [Place] = []
        if let data = UserDefaults.standard.object(forKey: "places") as? NSData {
            places = NSKeyedUnarchiver.unarchiveObject(with: data as Data) as! [Place]
        }
        
        places.append(place)
        let data = NSKeyedArchiver.archivedData(withRootObject: places)
        UserDefaults.standard.set(data, forKey: "places")
    }
    
    private func updateMap(activePlace: Place) {
        let region: MKCoordinateRegion = MKCoordinateRegion(center: activePlace.location, span: map.region.span)
        map.setRegion(region, animated: true)
        locationManager.stopUpdatingLocation()
    }
}
