//
//  LoginModel.swift
//  Wrike API Tool
//
//  Created by Mark Tapia on 7/12/20.
//  Copyright © 2020 Mark Tapia. All rights reserved.
//

import Foundation

class LoginModel {
    var initialSpaces = [IdentifiableWrikeObject]()
    var folderViewLaunch: ([IdentifiableWrikeObject]) -> ()
    
    init(folderViewLaunch: @escaping ([IdentifiableWrikeObject]) -> ()) {
        self.folderViewLaunch = folderViewLaunch
    }
    
    func gatherWrikeSpacesandTriggerLaunch() {
        addInitialSpaces()
    }
    
    func addInitialSpaces() {
        WrikeAPINetworkClient.shared.retrieveWrikeFolders(for: .GetSpaces, returnType: WrikeSpacesResponseObject.self) { result in
            switch result {
            case .Failure(with: let failureString):
                //TODO: Display failure
                fatalError(failureString)
            case .Success(with: let wrikeObject):
                self.initialSpaces.append(contentsOf: wrikeObject.data)
                self.addSharedWithMeSpace()
            }
        }
    }
    
    func addSharedWithMeSpace() {
        WrikeAPINetworkClient.shared.retrieveWrikeFolders(for: .GetAllFolders, returnType: WrikeAllFoldersResponseObject.self) { result in
            switch result {
            case .Failure(with: let failureString):
                fatalError(failureString)
            case .Success(with: let wrikeObject):
                self.initialSpaces.append(wrikeObject.data.first!)
                self.folderViewLaunch(self.initialSpaces)
            }
        }
    }
}
