//
//  AuthorizationCodeRequest.swift
//  Wrike API Tool
//
//  Created by Mark Tapia on 9/3/19.
//  Copyright © 2019 Mark Tapia. All rights reserved.
//

import Foundation

struct AuthorizationCodeRequest: ClientKeyRequestor {
    struct Constants {
        struct Keys {
            static let ClientId = "client_id"
            static let ResponseType = "response_type"
            static let RedirectUri = "redirect_uri"
        }
        
        struct Values {
            static let ClientId = getClientId()
            static let ResponseType = "code"
            static let RedirectUri = "https://mdtaps.com"
        }
    }
}
