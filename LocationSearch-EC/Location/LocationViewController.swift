//
//  LocationDetails.swift
//  LocationSearch-EC
//
//  Created by Mac Mini 2 on 10/21/20.
//
import MapKit
import UIKit
import Combine

class LocationViewController : UIViewController {
    
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var mapKitView: MKMapView!
        
    private var viewModel : LocationViewModel = { ()
        return LocationViewModel()
    }()
    private var cancellables = Set<AnyCancellable>()
//    private var listLocationViewController : ListLocationViewController?
//    private var halfModalTransitioningDelegate : HalfModalTransitioningDelegate?
    private var pendingRequestWorkItem: DispatchWorkItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
        configureBindings()
    }
    
    private func configureViews() {
        searchBar.delegate = self
        viewModel.startLocationManager()
    }
    
    private func configureBindings() {
        viewModel.$currentLocation.sink { (location) in
            guard let region = self.viewModel.currentRegion,
                  let pin = self.viewModel.pointAnnotation else {
                return
            }
            self.mapKitView.addAnnotation(pin)
            self.mapKitView.region = region
        }.store(in: &cancellables)
        viewModel.$dataSource.sink { (dataSource) in
            self.addMapMarker()
        }.store(in: &cancellables)
    }
    
    private func addMapMarker() {
        guard let mapAnnotations = self.viewModel.dataSource else { return }
        for item in mapAnnotations {
            guard let annotation = item.pointAnnotation else { continue }
            self.mapKitView.addAnnotation(annotation)
        }
    }
}

extension LocationViewController : UISearchBarDelegate {
    
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        // Cancel the currently pending item
//        pendingRequestWorkItem?.cancel()
//
//        // Wrap our request in a work item
//        let requestWorkItem = DispatchWorkItem { [weak self] in
//            self?.viewModel.requestLocation(query: searchText)
//        }
//
//        // Save the new work item and execute it after 250 ms
//        pendingRequestWorkItem = requestWorkItem
//        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(250),
//                                      execute: requestWorkItem)
//    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.resignFirstResponder()
        
        // Cancel the currently pending item
        pendingRequestWorkItem?.cancel()

        // Wrap our request in a work item
        let requestWorkItem = DispatchWorkItem { [weak self] in
            self?.viewModel.requestLocation(query: searchBar.text ?? "")
        }

        // Save the new work item and execute it after 250 ms
        pendingRequestWorkItem = requestWorkItem
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(250),
                                      execute: requestWorkItem)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.resignFirstResponder()
    }
}
