//
//  UserDefaults+Extension.swift
//  Wrike API Tool
//
//  Created by Mark Tapia on 9/3/19.
//  Copyright © 2019 Mark Tapia. All rights reserved.
//

import Foundation

extension UserDefaults {
    @objc dynamic var authCode: String? {
        return string(forKey: "authCode")
    }
    
    @objc dynamic var accessToken: String? {
        return string(forKey: "accessToken")
    }
    
    @objc dynamic var refreshToken: String? {
        return string(forKey: "refreshToken")
    }
    
    @objc dynamic var tokenType: String? {
        return string(forKey: "tokenType")
    }
    
    @objc dynamic var host: String? {
        return string(forKey: "host")
    }
    
}
