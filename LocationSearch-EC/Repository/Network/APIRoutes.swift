//
//  APIRoutes.swift
//  LocationSearch-EC
//
//  Created by Mac Mini 2 on 10/25/20.
//

import Foundation

class APIRoutes {
    static func getLocations(_ query: String, _ lat: Double, _ long: Double) -> EndPoints<ResultsModel>{
        let url = "https://places.demo.api.here.com/places/v1/discover/search?q=\(query)&Geolocation=geo%3A\(lat)%2C\(long)&app_id=DemoAppId01082013GAL&app_code=AJKnXv84fjrb0KIHawS0Tg"
        return EndPoints(urlString: url,
                         httpMethod: .GET)
    }
}
