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
    @available(iOS 13.0, *)
    func retrieveWrikeFolders<T: Decodable>(for requestMethod: APIRequestMethod, returnType: T.Type, _ completion: @escaping (_ response: Result<T>) -> Void) {
        
        WrikeLoginProcess.shared.loginToWrike { tokenIsSet in
            switch tokenIsSet {
            case false:
                completion(.Failure(with: "Token could not be set"))
            case true:
                let requestModel = WrikeAPIRequestModel(using: requestMethod)
                self.wrikeGETRequest(using: requestModel) { requestResult in
                    switch requestResult {
                    case .Failure(with: let failureString):
                        completion(.Failure(with: failureString))
                    case .Success(with: let data):
                        let decodeResult = self.decodeJsonData(from: data, returnType: returnType.self)
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
    }
    
    func decodeJsonData<T: Decodable>(from data: Data, returnType: T.Type) -> Result<T> {
        let decoder = JSONDecoder()
        do {
            let decodedJson = try decoder.decode(returnType.self, from: data)
            return .Success(with: decodedJson)
        } catch {
            return .Failure(with: error.localizedDescription)
        }
    }
}
