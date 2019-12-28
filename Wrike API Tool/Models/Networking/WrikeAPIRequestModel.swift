//
//  WrikeAPIRequestModel.swift
//  Wrike API Tool
//
//  Created by Mark Tapia on 12/21/19.
//  Copyright © 2019 Mark Tapia. All rights reserved.
//

import Foundation

struct WrikeAPIRequestModel {
    //MARK: Properties
    var urlPath: String!
    var urlQueryItems: [URLQueryItem]!
    var httpRequestMethod: HTTPRequestMethod!
    var returnType: WrikeResponseObject.Type!
    
    //MARK: Initializers
    init(using apiMethod: APIRequestMethod) {
        switch apiMethod {
        case .GetAllFolders:
            setPropertiesForAllFolders()
        case .GetFoldersFromListOfIds(let idsArray):
            setPropertiesForFolderList(folderList: idsArray)
        case .OtherMethod:
            print("Other method")
        }
    }
}

enum APIRequestMethod {
    case GetAllFolders
    case GetFoldersFromListOfIds([String])
    case OtherMethod(String)
}

enum HTTPRequestMethod: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case DELETE = "DELETE"
}
