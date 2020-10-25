//
//  LocationViewModel.swift
//  LocationSearch-EC
//
//  Created by Mac Mini 2 on 10/25/20.
//

import Foundation
import Combine
import CoreLocation
import MapKit

class LocationViewModel : Identifiable, ObservableObject {
    
    @Published private(set) var currentLocation : CLLocation?
    @Published private(set) var dataSource : [MapAnnotation]?
    @Published private(set) var error : Error?
    
    var currentRegion : MKCoordinateRegion? {
        guard currentLocation != nil else { return nil }
        let coordinate = CLLocationCoordinate2D(latitude: currentLocation!.coordinate.latitude,
                                                longitude: currentLocation!.coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)
        return MKCoordinateRegion(center: coordinate, span: span)
    }
    
    var pointAnnotation : MKPointAnnotation? {
        guard currentLocation != nil else { return nil }
        let pin = MKPointAnnotation()
        pin.coordinate = CLLocationCoordinate2D(latitude: currentLocation!.coordinate.latitude,
                                                longitude: currentLocation!.coordinate.longitude)
        pin.title = "Current Location"
        pin.subtitle = " "
        return pin
    }
    
    init() {
        LocationManager.sharedInstance.delegate = self
    }
    
    func requestLocation(query: String) {
        guard let location = currentLocation else { return }
        NetworkRequest.shared.request(type: APIRoutes.getLocations(
                                        query,
                                        location.coordinate.latitude,
                                        location.coordinate.longitude))
        { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let resultModel):
                self.dataSource = resultModel.results.items.map({ MapAnnotation($0) })
                break
            case .failure(let error):
                self.error = error
                break
            }
        }
    }
    
    func startLocationManager() {
        LocationManager.sharedInstance.startGeolocation()
    }
}

extension LocationViewModel : LocationManagerDelegate {
    func locationSuccessfullyFetched(location: CLLocation) {
        currentLocation = location
        CoreDataManager.shared.saveLocation(location.coordinate.latitude,
                                            location.coordinate.longitude,
                                            location.verticalAccuracy,
                                            completion: nil)
    }
    
    func locationFailedFetchingLocation(error: Error) {
        guard let location = CoreDataManager.shared.retrieveLocation() else { return }
        currentLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
    }
}
