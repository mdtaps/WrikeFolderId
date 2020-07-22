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
    var urlPath: String
    var urlQueryItems: [URLQueryItem]?
    var httpRequestMethod: HTTPRequestMethod
    
    //MARK: Initializers
    //Init for custom API call
    init(urlPath: String,
         urlQueryItems: [URLQueryItem]? = nil,
         httpRequestMethod: HTTPRequestMethod = .GET) {
        self.urlPath = urlPath
        self.urlQueryItems = urlQueryItems
        self.httpRequestMethod = httpRequestMethod
    }
    
    //Init for known request method
    init(using apiMethod: APIRequestMethod) {
        switch apiMethod {
        case .GetAllFolders:
            self.init(urlPath: "/folders")
        case .GetFoldersFromListOfIds(let idsArray):
            let urlPath = "/folders/" + WrikeAPIRequestModel.getStringForUrlPath(using: idsArray)
            self.init(urlPath: urlPath)
        case .GetSpaces:
            self.init(urlPath: "/spaces", urlQueryItems: [URLQueryItem(name: "userIsMember", value: "true")])
        case .GetFoldersFromSpaceId(let spaceId):
            self.init(urlPath: "/spaces/" + spaceId + "/folders")
        case .GetAccountData:
            self.init(urlPath: "/account")
        }
    }
}

enum APIRequestMethod {
    case GetAllFolders
    case GetFoldersFromListOfIds(idsArray: [String])
    case GetSpaces
    case GetFoldersFromSpaceId(spaceId: String)
    case GetAccountData
}

enum HTTPRequestMethod: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case DELETE = "DELETE"
}
