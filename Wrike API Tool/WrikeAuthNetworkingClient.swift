//
//  WrikeAuthNetworkingClient.swift
//  Wrike API Tool
//
//  Created by Mark Tapia on 8/1/19.
//  Copyright © 2019 Mark Tapia. All rights reserved.
//

import Foundation

class WrikeAuthNetworkingClient {
    static let shared = WrikeAuthNetworkingClient()

    private init() {}
    
    func wrikePOSTRequest(_ completion: @escaping (_ requestResult: Result<Data>) -> Void) {
        let url = getUrl()
        let urlRequest = getUrlRequest(using: url)
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                completion(.Failure(with: error.localizedDescription))
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.Failure(with: "No response from server"))
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                completion(.Failure(with: "Invalid, status code of \(httpResponse.statusCode)"))
                return
            }
            
            if let data = data {
                completion(.Success(with: data))
            } else {
                completion(.Failure(with: "No data returned"))
            }
        }
        
        
    }
    
    func getUrl() -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "www.wrike.com"
        components.path = "/oauth2/token"
        
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
    
    func getUrlRequest(using url: URL) -> URLRequest {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        
        return urlRequest
    }
}
