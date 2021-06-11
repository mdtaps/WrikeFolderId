//
//  WrikeObjectLoader.swift
//  Wrike API Tool
//
//  Created by Mark Tapia on 6/9/21.
//  Copyright © 2021 Mark Tapia. All rights reserved.
//

import Foundation

class WrikeObjectLoader {
    func loadChildObjects(for object: FolderData, completionHandler: @escaping (_ objects: [IdentifiableWrikeObject]) -> Void) {
        let dispatchGroup = DispatchGroup()
        let childIdsSplitIntoGroupsOfOneHundred = object.childIds.chunked(into: 100)
        var wrikeObjects = [IdentifiableWrikeObject]()
        
        for childIdGroup in childIdsSplitIntoGroupsOfOneHundred {
            dispatchGroup.enter()
            WrikeAPINetworkClient.shared.retrieveWrikeData(for: .GetFoldersFromListOfIds(idsArray: childIdGroup), returnType: WrikeFolderListResponseObject.self) { response in
                switch response {
                case .Failure(with: let failureString):
                    print("Get folders from list of ids failed with: \(failureString)")
                    dispatchGroup.leave()
                case .Success(with: let folderList):
                    wrikeObjects.append(contentsOf: folderList.data)
                    dispatchGroup.leave()
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            completionHandler(wrikeObjects)
        }
    }
    
    func loadChildObjects(for object: FolderObject, completionHandler: @escaping (_ objects: [IdentifiableWrikeObject]) -> Void) {
        let dispatchGroup = DispatchGroup()
        let childIdsSplitIntoGroupsOfOneHundred = object.childIds.chunked(into: 100)
        var wrikeObjects = [IdentifiableWrikeObject]()
        
        for childIdGroup in childIdsSplitIntoGroupsOfOneHundred {
            dispatchGroup.enter()
            WrikeAPINetworkClient.shared.retrieveWrikeData(for: .GetFoldersFromListOfIds(idsArray: childIdGroup), returnType: WrikeFolderListResponseObject.self) { response in
                switch response {
                case .Failure(with: let failureString):
                    print("Get folders from list of ids failed with: \(failureString)")
                    dispatchGroup.leave()
                case .Success(with: let folderList):
                    wrikeObjects.append(contentsOf: folderList.data)
                    dispatchGroup.leave()
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            completionHandler(wrikeObjects)
        }
    }
    
    func loadChildObjects(for object: SpaceObject, completionHandler: @escaping (_ objects: [IdentifiableWrikeObject]) -> Void) {
        WrikeAPINetworkClient.shared.retrieveWrikeData(for: .GetFoldersFromSpaceId(spaceId: object.id), returnType: WrikeAllFoldersResponseObject.self) { response in
            switch response {
            case .Failure(with: let failureString):
                print("Get folder from Space Id failed with: \(failureString)")
            case .Success(with: let folderListResponseObject):
                completionHandler(folderListResponseObject.data)
            }
        }
    }
}
