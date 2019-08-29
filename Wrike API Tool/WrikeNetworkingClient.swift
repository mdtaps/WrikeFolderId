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
                completion(.Failure(with: "Invalid, Status Code of \(httpResponse.statusCode)"))
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
        
        var queryItems = [URLQueryItem]()
        queryItems.append(URLQueryItem(name: AccessTokenRequestParameters.Constants.Keys.ClientId,
                                       value: AccessTokenRequestParameters.Constants.Values.ClientId))
        queryItems.append(URLQueryItem(name: AccessTokenRequestParameters.Constants.Keys.ClientSecret,
                                       value: AccessTokenRequestParameters.Constants.Values.ClientSecret))
        queryItems.append(URLQueryItem(name: AccessTokenRequestParameters.Constants.Keys.GrantType,
                                       value: AccessTokenRequestParameters.Constants.Values.GrantType))
        queryItems.append(URLQueryItem(name: AccessTokenRequestParameters.Constants.Keys.Code,
                                       value: AccessTokenRequestParameters.Constants.Values.Code))
        
        return components.url!
    }

    
    private func makeURLRequest(using url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        return request
    }
}

public enum Result<T> {
    case Success(with: T)
    case Failure(with: String)
}
