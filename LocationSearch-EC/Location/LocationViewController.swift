//
//  LocationDetails.swift
//  LocationSearch-EC
//
//  Created by Mac Mini 2 on 10/21/20.
//
import MapKit
import UIKit

class LocationViewController : UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var mapKitView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    private func configureViews() {
        searchBar.delegate = self    }
    
}

extension LocationViewController : UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
}


