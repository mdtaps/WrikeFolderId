//
//  WrikeResponseObjectModel.swift
//  Wrike API Tool
//
//  Created by Mark Tapia on 6/27/19.
//  Copyright © 2019 Mark Tapia. All rights reserved.
//

import Foundation

//Protocol used by all response objects to group
//them. For use in displaying and identifying.
@objc protocol IdentifiableWrikeObject {
    var id: String { get }
    var title: String { get }
    @objc optional var avatarUrl: String { get }
}

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
