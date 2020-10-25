//
//  NetworkRequest.swift
//  LocationSearch-EC
//
//  Created by Mac Mini 2 on 10/21/20.
//
import Foundation
import UIKit
import CoreData

typealias Completion<T> = (Swift.Result<(T), Error>) -> Void
typealias Parameters = Dictionary<String, Any>
typealias HTTPHeaders = Dictionary<String, String>

enum HTTPMethod : String {
    
    case GET = "get"
    case POST = "post"
    case PUT = "put"
    case DELETE = "delete"
}

class NetworkRequest {
    
    private var sessionConfiguration : URLSessionConfiguration
    private var urlSession : URLSession
    private let semaphore : DispatchSemaphore
    private let queue : DispatchQueue
    public static let shared = NetworkRequest()
    var retries = 0
    
    init() {
        self.queue = DispatchQueue.global(qos: .background)
        self.semaphore = DispatchSemaphore.init(value: 1)
        self.sessionConfiguration = URLSessionConfiguration.default
        self.urlSession = URLSession(configuration: sessionConfiguration)
    }
    
    /// # Generic #
    /// T: Represents Codable Model
    /// - parameter type: EndPoints<T> contains url, httpMethod, paramaters,, encoding, headers, and headers.
    /// Performs in background and synchronous request
    public func request<T: Codable>(type: EndPoints<T>, handler: @escaping Completion<T>) {
        var request = URLRequest(url: type.url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: type.timeout)
        request.httpMethod = type.httpMethod.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        self.queue.async {
            self.semaphore.wait()
            self.urlSession.dataTask(with: request) { (data, response, error) in
                DispatchQueue.main.async {
                    if let error = error {
                        handler(.failure(error))
                        return
                    }
                    let jsonDecoder = JSONDecoder()
//                    jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                    guard let data = data else { return }
                    do {
                        let decoded = try jsonDecoder.decode(T.self, from: data)
                        handler(.success(decoded))
                    } catch (let error) {
                        handler(.failure(error))
                    }
                    self.semaphore.signal()
                }
            }.resume()
        }
    }
}

extension NSMutableData {
    func appendString(_ string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
        append(data!)
    }
}
