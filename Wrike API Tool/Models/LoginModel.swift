//
//  LoginModel.swift
//  Wrike API Tool
//
//  Created by Mark Tapia on 7/12/20.
//  Copyright © 2020 Mark Tapia. All rights reserved.
//

import Foundation
import UIKit

class LoginModel {
    var initialSpaces = [IdentifiableWrikeObject]()
    var folderViewLaunch: ([IdentifiableWrikeObject]) -> ()
    
    init(folderViewLaunch: @escaping ([IdentifiableWrikeObject]) -> ()) {
        self.folderViewLaunch = folderViewLaunch
    }
}

extension LoginModel {
    func gatherWrikeSpacesandTriggerLaunch() {
        addInitialSpaces()
    }
    
    private func addInitialSpaces() {
        WrikeAPINetworkClient.shared.retrieveWrikeData(for: .GetSpaces, returnType: WrikeSpacesResponseObject.self) { result in
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
    
    private func addSharedWithMeSpace() {
        WrikeAPINetworkClient.shared.retrieveWrikeData(for: .GetAllFolders, returnType: WrikeAllFoldersResponseObject.self) { result in
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
