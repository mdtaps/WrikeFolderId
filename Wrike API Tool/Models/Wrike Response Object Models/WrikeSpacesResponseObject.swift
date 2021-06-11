//
//  WrikeSpacesResponseObject.swift
//  Wrike API Tool
//
//  Created by Mark Tapia on 4/24/20.
//  Copyright © 2020 Mark Tapia. All rights reserved.
//

import Foundation
import UIKit

struct WrikeSpacesResponseObject: Decodable {
    let kind: String
    let data: [SpaceObject]
}
    
class SpaceObject: Decodable, IdentifiableWrikeObject {
    func setImage(for imageView: UIImageView) {
        imageView.loadImage(at: avatarUrl)
    }
    
    func getChildObjects(completionHandler: @escaping ([IdentifiableWrikeObject]) -> Void) {
        let wrikeObjectLoader = WrikeObjectLoader()
        wrikeObjectLoader.loadChildObjects(for: self, completionHandler: completionHandler)
    }
    
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
