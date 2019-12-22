//
//  WrikeAPINetworkClient+HelperFunctions.swift
//  Wrike API Tool
//
//  Created by Mark Tapia on 7/2/19.
//  Copyright © 2019 Mark Tapia. All rights reserved.
//

import Foundation
import UIKit

extension WrikeAPINetworkClient {
    func retrieveWrikeFolders(_ completion: @escaping (_ response: Result<WrikeAllFoldersResponseObject>) -> Void) {
        
        WrikeLoginProcess.shared.loginToWrike { tokenIsSet in
            switch tokenIsSet {
            case false:
                completion(.Failure(with: "Token could not be set"))
            case true:
                self.wrikeGETRequest { (requestResult) in
                    switch requestResult {
                    case .Failure(with: let failureString):
                        completion(.Failure(with: failureString))
                    case .Success(with: let data):
                        let decodeResult = decodeJsonData(from: data)
                        switch decodeResult {
                        case .Failure(with: let failureString):
                            completion(.Failure(with: failureString))
                        case .Success(with: let wrikeObject):
                            completion(.Success(with: wrikeObject))
                        }
                    }
                }
            }
        }
        
        func decodeJsonData(from data: Data) -> Result<WrikeAllFoldersResponseObject> {
            let decoder = JSONDecoder()
            
            do {
                let decodedJson = try decoder.decode(WrikeAllFoldersResponseObject.self, from: data)
                return .Success(with: decodedJson)
            } catch {
                return .Failure(with: error.localizedDescription)
            }
        }
    }
}
