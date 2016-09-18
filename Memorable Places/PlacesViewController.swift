//
//  PlacesViewController.swift
//  Memorable Places
//
//  Created by Kyle Hodgetts on 16/09/16.
//  Copyright © 2016 com.github.kylehodgetts. All rights reserved.
//

import UIKit

class PlacesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    static let placesArrayKey = "places"
    
    @IBOutlet var table: UITableView!
    var places: [Place]!
    var activePlace: Place?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(PlacesViewController.updateTable), name: .placesNotifyUpdate, object: nil)
        
        updateTable()
        print(places)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMemorablePlace" {
            if let ap = activePlace {
                let mapVC = segue.destination as! MapViewController
                mapVC.activePlace = ap
            }
        }
    }
    
    // END MARK: - Navigation
    
    // MARK: - Table delegate methods
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        cell.textLabel?.text = places[indexPath.row].name
        return cell
    }
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        activePlace = places[indexPath.row]
        performSegue(withIdentifier: "showMemorablePlace", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            places.remove(at: indexPath.row)
            table.deleteRows(at: [indexPath], with: .automatic)
            
            updateStorage()
        }
    }
    
    // END MARK: - Table delegate methods
    
    // MARK: - Helper methods for updating data and UI
    
    // Not private so it is accessible to post notification in MapVC to update table
    // when a new place is added
    func updateTable() {
        if let data = UserDefaults.standard.object(forKey: "places") as? NSData {
            places = NSKeyedUnarchiver.unarchiveObject(with: data as Data) as! [Place]
        }
        if places == nil {
            places = []
        }
        table.reloadData()
    }
    
    private func updateStorage() {
        let data = NSKeyedArchiver.archivedData(withRootObject: places)
        UserDefaults.standard.set(data, forKey: PlacesViewController.placesArrayKey)
    }
    // END MARK: - Helper methods for updating data and UI

    
    // TODO If array is empty, provide a message to add a place
}
