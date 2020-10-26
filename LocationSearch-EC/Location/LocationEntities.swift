//
//  LocationEntities.swift
//  LocationSearch-EC
//
//  Created by Mac Mini 2 on 10/25/20.
//

import Foundation
import MapKit

struct ResultsModel : Codable {
    var results : Results
    var search : SearchModel
    
    class Results : Codable {
        var items : [ItemModel]
    }
}

struct ItemModel : Codable {
    var position : [Double]
    var bbox : [Double]?
    var distance : Int
    var title : String
    var averageRating : Float
    var category : CategoryModel
    var icon : String
    var vicinity : String
    var address : AddressModel
    var contacts : ContactsModel?
//    var having : []
    var type : String
    var href : String
    var id : String
    var authoratative : Bool?
    var access : [AccessModel]?
}

struct ContactsModel : Codable {
    var phone : [PhoneModel]
}

struct PhoneModel : Codable {
    var value : String
    var label : String
}

struct CategoryModel : Codable {
    var id : String
    var title : String
    var href : String
    var type : String
    var system : String
}

struct AccessModel : Codable {
    var position : [Double]
    var accessType : String
    var sideOfStreet : String
}

struct SearchModel : Codable {
    var context : ContextModel
    var ranking : String
}

struct ContextModel : Codable {
    var location : LocationModel
}

struct LocationModel : Codable {
    var position : [Double]
    var address : AddressModel
    var type : String?
    var href : String?
}

struct AddressModel : Codable {
    var text : String
    var house : String?
    var street : String?
    var postalCode : String?
    var district : String?
    var city : String?
    var county : String?
    var stateCode : String?
    var country : String?
    var countryCode : String?
}

struct MapAnnotation {
    
    var item : ItemModel
    private var currentLatitude : Double
    private var currentLongitude : Double
    private var currentCoordinate : CLLocation

    
    init(_ item: ItemModel, _ currentLatitude: Double, _ currentLongitude: Double) {
        self.item = item
        self.currentLatitude = currentLatitude
        self.currentLongitude = currentLongitude
        self.currentCoordinate = CLLocation(latitude: currentLatitude, longitude: currentLongitude)
    }
    
    var pointAnnotation : MKPointAnnotation? {
        guard let latitude = item.position.first,
              let longitude = item.position.last else {
            return nil
        }
        let pin = MKPointAnnotation()
        pin.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        pin.title = item.title
        let pinCoordinate = CLLocation(latitude: latitude, longitude: longitude)
        let distance = currentCoordinate.distance(from: pinCoordinate)
        pin.subtitle = "Distance: \(distance)"
        return pin
    }
}
