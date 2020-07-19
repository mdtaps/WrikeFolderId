//
//  WrikeCustomFieldResponseObject.swift
//  Wrike API Tool
//
//  Created by Mark Tapia on 7/18/20.
//  Copyright © 2020 Mark Tapia. All rights reserved.
//

import Foundation

struct WrikeCustomFieldData: Decodable {
    let id: String
    let accountId: String
    let title: String
    let type: String
    let sharedIds: [String]
    let settings: [WrikeCustomFieldSettings]?
    
    struct WrikeCustomFieldSettings: Decodable {
        let inheritanceType: String?
        let decimalPlaces: String?
        let useThousandsSeparator: Bool?
        let currency: String?
        let aggregation: String?
        let values: [String]?
        let allowOtherValues: Bool?
        let contacts: [String]?
    }
}
