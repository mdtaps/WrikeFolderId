//
//  WrikeNetworkingClient.swift
//  Wrike API Tool
//
//  Created by Mark Tapia on 7/2/19.
//  Copyright © 2019 Mark Tapia. All rights reserved.
//

import Foundation

class WrikeNetworkClient {
    
    static let shared = WrikeNetworkClient()
    
    private init() {}
    
    func wrikeGETRequest(_ completion: @escaping (_ requestResult: Result<Data>) -> Void) {
        let url = getUrl()
        let urlRequest = makeURLRequest(using: url)
        
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
    
    func getUrl() -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "www.wrike.com" //TODO: Get host from response
        components.path = "/api/v4/folders"
        
        return components.url!
    }
    
    private func makeURLRequest(using url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        let defaults = UserDefaults.standard
        
        request.httpMethod = "GET"
        
        //TODO: Build model for getting values
        request.addValue(defaults.tokenType! + " " + defaults.accessToken!, forHTTPHeaderField: "Authorization")
        return request
    }
}

public enum Result<T> {
    case Success(with: T)
    case Failure(with: String)
}
