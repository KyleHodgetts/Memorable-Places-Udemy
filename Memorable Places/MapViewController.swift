//
//  ViewController.swift
//  Memorable Places
//
//  Created by Kyle Hodgetts on 16/09/16.
//  Copyright © 2016 com.github.kylehodgetts. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var map: MKMapView!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        map.delegate = self
    }
}

