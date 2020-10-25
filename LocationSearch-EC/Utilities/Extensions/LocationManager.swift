//
//  LocationManager.swift
//  LocationSearch-EC
//
//  Created by Mac Mini 2 on 10/24/20.
//

import Foundation

import CoreLocation
import MapKit

protocol LocationManagerDelegate : class {
    
    func locationSuccessfullyFetched(location: CLLocation)
    func locationFailedFetchingLocation(error: Error)
}

class LocationManager : NSObject, CLLocationManagerDelegate{
    
    // MARK: Singleton
    public static let sharedInstance = LocationManager()
    
    // MARK: Public Properties
    public weak var delegate : LocationManagerDelegate?
    public var isAbleToFetchLocation : Bool = false
    
    // MARK: Private Properties
    private var coreLocationManager : CLLocationManager?
    
    // MARK: Initializers
    private override init(){
        
        self.coreLocationManager = CLLocationManager()
        
        super.init();
        
        self.coreLocationManager?.delegate = self
        self.coreLocationManager?.requestWhenInUseAuthorization()
        self.coreLocationManager?.desiredAccuracy = kCLLocationAccuracyBest
        self.coreLocationManager?.stopUpdatingLocation()
    }
    
    // MARK: Core Location Manager Delegate Methods
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let fetchedLocation = locations.last {
            if (CLLocationCoordinate2DIsValid(fetchedLocation.coordinate)) {
                self.delegate?.locationSuccessfullyFetched(location: fetchedLocation)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        delegate?.locationFailedFetchingLocation(error: error)
    }
    
    func locationManagerDidResumeLocationUpdates(_ manager: CLLocationManager) { }
    
    func locationManagerDidPauseLocationUpdates(_ manager: CLLocationManager) { }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        var locationServiceStatus : String?
        
        switch (status) {
            
        case .notDetermined:
            
            self.isAbleToFetchLocation = false
            self.pauseGeolocation()
            locationServiceStatus = "Location Services Changed Authorization: Not Determined"
        case .restricted:
            
            self.isAbleToFetchLocation = false
            self.pauseGeolocation()
            locationServiceStatus = "Location Services Changed Authorization: Restricted"
        case .denied:
            
            self.isAbleToFetchLocation = false
            self.pauseGeolocation()
            locationServiceStatus = "Location Services Changed Authorization: Denied"
        case.authorizedWhenInUse:
            
            self.isAbleToFetchLocation = true
            locationServiceStatus = "Location Services Changed Authorization: Authorized When in Use"
        case.authorizedAlways:
            
            self.isAbleToFetchLocation = true
            locationServiceStatus = "Location Services Changed Authorization: Authorized Always"
        default:
            break
        }
                
        print(locationServiceStatus!)
    }
    
    // MARK: Utility Methods
    public func startGeolocation(){
        guard let manager = self.coreLocationManager else { return }
        manager.startUpdatingLocation()
    }
    
    public func pauseGeolocation(){
        guard let manager = self.coreLocationManager else { return }
        manager.stopUpdatingLocation()
    }
}
