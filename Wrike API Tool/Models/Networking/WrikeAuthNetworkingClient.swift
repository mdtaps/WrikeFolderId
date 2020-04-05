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
    
    func wrikePOSTRequest(requestType: AuthorizationRequestType, _ completion: @escaping (_ requestResult: Result<Data>) -> Void) {
        let url = getUrl(requestType: requestType)
        let urlRequest = makeUrlRequest(using: url)
        
        dump(urlRequest)
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                completion(.Failure(with: error.localizedDescription))
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.Failure(with: "No response from server"))
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                completion(.Failure(with: "Auth Request Invalid, status code of \(httpResponse.statusCode), \(HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode))"))
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
    
    private func getUrl(requestType: AuthorizationRequestType) -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "www.wrike.com"
        components.path = "/oauth2/token"
        
        components.queryItems = getQueryItems(using: requestType)
        
        print("Auth Request URL: \(components.url!)")
        
        return components.url!
    }
    
    private func getQueryItems(using requestType: AuthorizationRequestType) -> [URLQueryItem] {
        var queryItems = [URLQueryItem]()
        queryItems.append(URLQueryItem(name: AccessTokenRequestParameters.Constants.Keys.ClientId,
                                       value: AccessTokenRequestParameters.Constants.Values.ClientId))
        queryItems.append(URLQueryItem(name: AccessTokenRequestParameters.Constants.Keys.ClientSecret,
                                       value: AccessTokenRequestParameters.Constants.Values.ClientSecret))
        queryItems.append(URLQueryItem(name: AccessTokenRequestParameters.Constants.Keys.GrantType,
                                       value: requestType.rawValue))

        let grantQueryKey: String
        let grantQueryValue: String
        print("Request Type for Auth: \(requestType)")
        switch requestType {
        case .authorizationCode:
            //TODO: Set grant query key to requestType, update request type to whatever it needs to be for raw value to work
            //for both .authorizationCode and .refreshToken
            grantQueryKey = AccessTokenRequestParameters.Constants.Keys.Code
            grantQueryValue = UserDefaults.standard.authCode!
        case .refreshToken:
            grantQueryKey = requestType.rawValue
            grantQueryValue = UserDefaults.standard.refreshToken!
        }
        
        queryItems.append(URLQueryItem(name: grantQueryKey, value: grantQueryValue))

        queryItems.append((URLQueryItem(name: AuthorizationCodeRequest.Constants.Keys.RedirectUri, value: AuthorizationCodeRequest.Constants.Values.RedirectUri)))
        
        return queryItems
    }
    
    private func makeUrlRequest(using url: URL) -> URLRequest {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        
        return urlRequest
    }
}
