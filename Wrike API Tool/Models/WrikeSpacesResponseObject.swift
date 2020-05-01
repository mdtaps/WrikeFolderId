//
//  WrikeSpacesResponseObject.swift
//  Wrike API Tool
//
//  Created by Mark Tapia on 4/24/20.
//  Copyright © 2020 Mark Tapia. All rights reserved.
//

import Foundation

struct WrikeSpacesResponseObject: Decodable {
    let kind: String
    let data: SpaceData
    
    class SpaceData: Decodable, IdentifiableWrikeObject {
        let id: String
        let title: String
        let avatarUrl: String
        let accessType: SpaceAccessType
        let archived: Bool
        
        enum SpaceAccessType: String, Decodable {
            case Public
            case Personal
            case Private
        }
    }
}
