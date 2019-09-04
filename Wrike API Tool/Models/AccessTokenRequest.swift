//
//  AccessTokenRequest.swift
//  Wrike API Tool
//
//  Created by Mark Tapia on 7/28/19.
//  Copyright © 2019 Mark Tapia. All rights reserved.
//

import Foundation

struct AccessTokenResponseObject: Codable {
    var access_token: String
    var refresh_token: String
    var token_type: String
    var expires_in: String
    var host: String
}

struct AccessTokenRequestParameters: ClientKeyRequestor {
    struct Constants {
        struct Keys {
            static var ClientId = "client_id"
            static var ClientSecret = "client_secret"
            static var GrantType = "grant_type"
            static var Code = "code"
        }
        
        struct Values {
            static var ClientId = getClientId()
            static var ClientSecret = getClientSecret()
            static var GrantType = "authorization_code"
            static var Code = getAuthCode()
        }
    }
    
    private static func getAuthCode() -> String {
        return UserDefaults.standard.authCode!
    }
}


