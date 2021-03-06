//
//  ClientKeyRequestor.swift
//  Wrike API Tool
//
//  Created by Mark Tapia on 9/3/19.
//  Copyright © 2019 Mark Tapia. All rights reserved.
//

import Foundation

//Protocol to conform to for members requesting client keys
//from ClientKeys.plist
protocol ClientKeyRequestor {
    static func getClientId() -> String
    static func getClientSecret() -> String
}

extension ClientKeyRequestor {
    static func getClientId() -> String {
        let clientKeysDict = getClientKeys()
        
        guard let clientIdString = clientKeysDict?["client_id"] as? String else {
            fatalError("Could not find client_id in ClientKeys.plist")
        }
        
        return clientIdString
    }
    
    static func getClientSecret() -> String {
        let clientKeysDict = getClientKeys()
        
        guard let clientSecretString = clientKeysDict?["client_secret"] as? String else {
            fatalError("Could not find client_secret in ClientKeys.plist")
        }
        
        return clientSecretString
    }
    
    //Helper function to get ClientKeys.plist as NSDictionary
    static func getClientKeys() -> NSDictionary? {
        guard let path = Bundle.main.path(forResource: "ClientKeys", ofType: "plist") else {
            fatalError("Could not find ClientKeys.plist")
        }
        
        return NSDictionary(contentsOfFile: path)
    }
}
