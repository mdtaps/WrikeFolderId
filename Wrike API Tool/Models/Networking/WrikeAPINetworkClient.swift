//
//  WrikeAPINetworkClient.swift
//  Wrike API Tool
//
//  Created by Mark Tapia on 7/2/19.
//  Copyright © 2019 Mark Tapia. All rights reserved.
//

import Foundation

class WrikeAPINetworkClient {
    
    static let shared = WrikeAPINetworkClient()
    
    private init() {}
    
    func wrikeGETRequest(using requestData: WrikeAPIRequestModel, _ completion: @escaping (_ requestResult: Result<Data>) -> Void) {
        let url = getUrl(using: requestData.urlPath)
        let urlRequest = makeURLRequest(using: url, withMethod: requestData.httpRequestMethod.rawValue)
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                completion(.Failure(with: error.localizedDescription))
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.Failure(with: "No response from server"))
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                completion(.Failure(with: "Token Request Invalid, Status Code of \(httpResponse.statusCode)"))
                return
            }
            
            if let data = data {
                completion(.Success(with: data))
            } else {
                completion(.Failure(with: "No data returned"))
            }
        }
        
        task.resume()
    }
    
    func getUrl(using urlPath: String) -> URL {
        var components = URLComponents()
        let defaults = UserDefaults.standard
        
        components.scheme = "https"
        components.host = defaults.host ?? "www.wrike.com"
        components.path = "/api/v4" + urlPath
        
        
        return components.url!
    }
    
    private func makeURLRequest(using url: URL, withMethod httpMethod: String) -> URLRequest {
        var request = URLRequest(url: url)
        let defaults = UserDefaults.standard
        
        request.httpMethod = httpMethod
        
        //TODO: Check why nil sometimes gets returned
        request.addValue(defaults.tokenType! + " " + defaults.accessToken!, forHTTPHeaderField: "Authorization")
        return request
    }
}

public enum Result<T> {
    case Success(with: T)
    case Failure(with: String)
}
