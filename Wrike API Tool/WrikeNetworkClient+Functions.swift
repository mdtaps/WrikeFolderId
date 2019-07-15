//
//  WrikeNetworkClient+Functions.swift
//  Wrike API Tool
//
//  Created by Mark Tapia on 7/2/19.
//  Copyright © 2019 Mark Tapia. All rights reserved.
//

import Foundation
import UIKit

extension WrikeNetworkClient {
    func retrieveWrikeFolders(_ completion: @escaping (_ response: Result<WrikeResponseObject>) -> Void) {
        
        wrikeGETRequest { (requestResult) in
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
        
        func decodeJsonData(from data: Data) -> Result<WrikeResponseObject> {
            let decoder = JSONDecoder()
            
            do {
                let decodedJson = try decoder.decode(WrikeResponseObject.self, from: data)
                print("Decoded JSON: \(decodedJson)")
                return .Success(with: decodedJson)
            } catch {
                return .Failure(with: error.localizedDescription)
            }
        }
    }
}
