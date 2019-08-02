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
    }
    
    func getUrl() -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "www.wrike.com" //TODO: Get host from response
        components.path = "/oauth2/token"
        
        var queryItems = [URLQueryItem]()
        queryItems.append(URLQueryItem(name: AccessTokenRequestParameters.Constants.Keys.ClientId,
                                       value: AccessTokenRequestParameters.Constants.Values.ClientId))
        queryItems.append(URLQueryItem(name: AccessTokenRequestParameters.Constants.Keys.ClientSecret,
                                       value: AccessTokenRequestParameters.Constants.Values.ClientSecret))
        queryItems.append(URLQueryItem(name: AccessTokenRequestParameters.Constants.Keys.GrantType,
                                       value: AccessTokenRequestParameters.Constants.Values.GrantType))
        queryItems.append(URLQueryItem(name: AccessTokenRequestParameters.Constants.Keys.Code,
                                       value: nil)) //TODO: Get Access code
        
        return components.url!
    }
    
    func getUrlRequest(using url: URL) -> URLRequest {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        
        return urlRequest
    }
}
