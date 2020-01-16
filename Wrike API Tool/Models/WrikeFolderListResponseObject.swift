//
//  WrikeFolderListResponseObject.swift
//  Wrike API Tool
//
//  Created by Mark Tapia on 12/21/19.
//  Copyright © 2019 Mark Tapia. All rights reserved.
//

import Foundation

struct WrikeFolderListResponseObject: Decodable {
    let kind: String
    let data: [FolderObject]

    struct FolderObject: Decodable {
        let id: String
        let accountId: String
        let title: String
        let creationDate: String
        let updatedDate: String
        let briefDescription: String?
        let description: String
        let color: String?
        let sharedIds: [String]
        let parentIds: [String]
        let childIds: [String]
        let superParentIds: [String]
        let scope: String
        let hasAttachments: Bool
        let attachmentCount: Int?
        let permalink: String
        let workflowId: String
        let metadata: [MetaData]?
        let customFields: [CustomField]?
        let customColumnIds: [String]?
        let project: Project?
    }
    
    struct MetaData: Decodable {
        let key: String
        let value: String
    }
    
    struct CustomField: Decodable {
        let id: String
        let value: String
    }
}
