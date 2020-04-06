//
//  AccessTokenRequest.swift
//  Wrike API Tool
//
//  Created by Mark Tapia on 7/28/19.
//  Copyright © 2019 Mark Tapia. All rights reserved.
//

import Foundation

struct AccessTokenResponseObject: Codable {
    var accessToken: String
    var refreshToken: String
    var tokenType: String
    var expiresIn: Int
    var host: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
        case host
    }
    
    func writeToDefaults() {
        let defaults = UserDefaults.standard
        let currentUnixTimeMinusOneMinute = Date().timeIntervalSince1970 - 60
        
        defaults.set(accessToken, forKey: "accessToken")
        defaults.set(refreshToken, forKey: "refreshToken")
        defaults.set(tokenType, forKey: "tokenType")
        defaults.set(expiresIn, forKey: "expiresIn")
        defaults.set(host, forKey: "host")
        defaults.set(currentUnixTimeMinusOneMinute + TimeInterval(expiresIn), forKey: "expirationTime")
    }
}

struct AccessTokenRequestParameters: ClientKeyRequestor {
    struct Constants {
        struct Keys {
            static var ClientId = "client_id"
            static var ClientSecret = "client_secret"
            static var GrantType = "grant_type"
            static var Code = "code"
            static var RefreshToken = "refresh_token"
        }
        
        struct Values {
            static var ClientId = getClientId()
            static var ClientSecret = getClientSecret()
        }
    }
}

enum AuthorizationRequestType: String {
    case authorizationCode = "authorization_code"
    case refreshToken = "refresh_token"
}


