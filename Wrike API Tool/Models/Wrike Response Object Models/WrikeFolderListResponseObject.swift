//
//  WrikeFolderListResponseObject.swift
//  Wrike API Tool
//
//  Created by Mark Tapia on 12/21/19.
//  Copyright © 2019 Mark Tapia. All rights reserved.
//

import Foundation
import UIKit

struct WrikeFolderListResponseObject: Decodable {
    let kind: String
    let data: [FolderObject]
}

class FolderObject: Decodable, IdentifiableWrikeObject {
    func setImage(for imageView: UIImageView) {
        let imageTitle = project != nil ? "clipboard" : "folder"
        imageView.image = UIImage(named: imageTitle) ?? UIImage()
    }
    
    func getChildObjects(completionHandler: @escaping ([IdentifiableWrikeObject]) -> Void) {
        let wrikeObjectLoader = WrikeObjectLoader()
        wrikeObjectLoader.loadChildObjects(for: self, completionHandler: completionHandler)
    }
    
    let id: String
    let accountId: String
    let title: String
    let createdDate: String
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
