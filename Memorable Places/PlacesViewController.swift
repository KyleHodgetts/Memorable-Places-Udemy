//
//  PlacesViewController.swift
//  Memorable Places
//
//  Created by Kyle Hodgetts on 16/09/16.
//  Copyright © 2016 com.github.kylehodgetts. All rights reserved.
//

import UIKit

class PlacesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var table: UITableView!
    var places: [Place]!
    var activePlace: Place?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(PlacesViewController.updateTable), name: .placesNotifyUpdate, object: nil)
        
        updateTable()
        print(places)
    }
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        cell.textLabel?.text = places[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        activePlace = places[indexPath.row]
        performSegue(withIdentifier: "showMemorablePlace", sender: nil)
    }
    
    func updateTable() {
        if let data = UserDefaults.standard.object(forKey: "places") as? NSData {
            places = NSKeyedUnarchiver.unarchiveObject(with: data as Data) as! [Place]
        }
        if places == nil {
            places = []
        }
        table.reloadData()
    }
    
    // TODO If array is empty, provide a message to add a place
    // TODO when a place is clicked, reaveals map with pin (segue)
    // TODO process a place from MAP

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMemorablePlace" {
            if let ap = activePlace {
                let mapVC = segue.destination as! MapViewController
                mapVC.activePlace = ap
                
            }
        }
    }

}
