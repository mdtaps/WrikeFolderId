//
//  WrikeResponseObjectModel.swift
//  Wrike API Tool
//
//  Created by Mark Tapia on 6/27/19.
//  Copyright © 2019 Mark Tapia. All rights reserved.
//

import Foundation

protocol WrikeResponseObject: Decodable { }

extension WrikeResponseObject {
    static func getUnderlyingType() -> Self.Type {
        return Self.self
    }
}

struct WrikeAllFoldersResponseObject: WrikeResponseObject {
    let kind: String
    let data: [FolderData]
}

struct FolderData: Codable {
    let id: String
    let title: String
    let color: String?
    let childIds: [String]
    let scope: String
    let project: Project?
}

struct Project: Codable {
    let authorId: String?
    let ownerIds: [String]
    let customStatusId: String?
    let startDate: String?
    let endDate: String?
    let createdDate: String?
    let completedDate: String?
    let status: String?
}
