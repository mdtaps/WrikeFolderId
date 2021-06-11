//
//  WrikeResponseObjectModel.swift
//  Wrike API Tool
//
//  Created by Mark Tapia on 6/27/19.
//  Copyright © 2019 Mark Tapia. All rights reserved.
//

import Foundation
import UIKit

struct WrikeAllFoldersResponseObject: Decodable {
    let kind: String
    let data: [FolderData]
}

class FolderData: Decodable, IdentifiableWrikeObject {
    let id: String
    let title: String
    let color: String?
    let childIds: [String]
    let scope: String
    let project: Project?
    
    func setImage(for imageView: UIImageView) {
        let imageTitle = project != nil ? "clipboard" : "folder"
        imageView.image = UIImage(named: imageTitle) ?? UIImage()
    }
    
    func getChildObjects(completionHandler: @escaping ([IdentifiableWrikeObject]) -> Void) {
        let wrikeObjectLoader = WrikeObjectLoader()
        wrikeObjectLoader.loadChildObjects(for: self, completionHandler: completionHandler)
    }
    
    func getChildIds(completionHandler: @escaping ([String]) -> Void) {
        completionHandler(childIds)
    }
}

struct Project: Decodable {
    let authorId: String?
    let ownerIds: [String]
    let customStatusId: String?
    let startDate: String?
    let endDate: String?
    let createdDate: String?
    let completedDate: String?
    let status: String?
}
