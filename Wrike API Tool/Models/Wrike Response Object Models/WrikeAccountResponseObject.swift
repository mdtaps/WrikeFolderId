//
//  WrikeAccountResponseObject.swift
//  Wrike API Tool
//
//  Created by Mark Tapia on 7/18/20.
//  Copyright © 2020 Mark Tapia. All rights reserved.
//

import Foundation

struct WrikeAccountResponseObject: Decodable {
    let kind: String
    let data: [WrikeAccountData]
}

struct WrikeAccountData: Decodable {
    let id: String
    let name: String
    let dateFormat: String
    let firstDayOfWeek: String
    let workDays: [String]
    let rootFolderId: String
    let recycleBinId: String
    let createdDate: String
    let subscription: WrikeSubscription?
    let metadata: [MetaData]?
    let customField: [WrikeCustomFieldData]?
    let joinedDate: String
    
    struct WrikeSubscription: Decodable {
        let type: String
        let suspended: Bool
        let paid: Bool
        let userLimit: Int
    }
}
