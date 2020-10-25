//
//  EndPoints.swift
//  LocationSearch-EC
//
//  Created by Mac Mini 2 on 10/21/20.
//

import Foundation
import CoreData

struct EndPoints<T> {
    var httpMethod: HTTPMethod
    var headers: HTTPHeaders?
    var timeout: TimeInterval = 20
    var httpBody: Data?
    
    var url: URL
    var resourcePath : String = ""
    
    init(resourcePath: String,
         httpMethod: HTTPMethod,
         timeout: TimeInterval = 10,
         managedObjectContext: NSManagedObjectContext? = nil) {
        self.resourcePath = resourcePath
        self.url = URL(string: "https://api.github.com/" + resourcePath)!
        self.httpMethod = httpMethod
        self.timeout = timeout
    }
    
    init(urlString: String,
         httpMethod: HTTPMethod,
         timeout: TimeInterval = 10,
         managedObjectContext: NSManagedObjectContext? = nil) {
        self.url = URL(string: urlString)!
        self.httpMethod = httpMethod
        self.timeout = timeout
    }
}
