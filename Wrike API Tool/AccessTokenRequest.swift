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

struct AccessTokenRequestParameters {
    struct Constants {
        struct Keys {
            static var ClientId = "client_id"
            static var ClientSecret = "client_secret"
            static var GrantType = "grant_type"
            static var Code = "code"
        }
        
        struct Values {
            static var ClientId = getClientIdString()
            static var ClientSecret = getClientSecretString()
            static var GrantType = "authorization_code"
            static var Code = getAuthCode()
        }
    }
    

    
    private static func getClientIdString() -> String {
        guard let path = Bundle.main.path(forResource: "ClientKey", ofType: "plist") else {
            fatalError("Could not find ClientKey.plist")
        }
        
        let clientKeysDict = NSDictionary(contentsOfFile: path)
        
        guard let clientIdString = clientKeysDict?["client_id"] as? String else {
            fatalError("Could not find client_id in ClientKey.plist")
        }
        
        return clientIdString
    }
    
    private static func getClientSecretString() -> String {
        guard let path = Bundle.main.path(forResource: "ClientKey", ofType: "plist") else {
            fatalError("Could not find ClientKey.plist")
        }
        
        let clientKeysDict = NSDictionary(contentsOfFile: path)
        
        guard let clientSecretString = clientKeysDict?["client_secret"] as? String else {
            fatalError("Could not find client_secret in ClientKey.plist")
        }
        
        return clientSecretString
    }
    
    private static func getAuthCode() -> String {
        return UserDefaults.standard.string(forKey: "authCode")!
    }
}


