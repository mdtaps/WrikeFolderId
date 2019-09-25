//
//  WrikeAuthNetworkingClient+Functions.swift
//  Wrike API Tool
//
//  Created by Mark Tapia on 8/5/19.
//  Copyright © 2019 Mark Tapia. All rights reserved.
//

import Foundation

extension WrikeAuthNetworkingClient {
    func getAccessToken(_ completion: @escaping (_ response: Result<AccessTokenResponseObject>) -> Void) {        
        wrikePOSTRequest { result in
            switch result {
            case .Failure(with: let failureString):
                completion(.Failure(with: failureString))
            case .Success(with: let responseData):
                let decodeResult = self.decodeJsonData(from: responseData)
                
                switch decodeResult {
                case .Failure(with: let failureString):
                    completion(.Failure(with: failureString))
                case .Success(with: let accessTokenResponseObject):
                    completion(.Success(with: accessTokenResponseObject))
                }
            }
        }
    }
    
    func decodeJsonData(from data: Data) -> Result<AccessTokenResponseObject> {
        let decoder = JSONDecoder()
        
        do {
            let json = try decoder.decode(AccessTokenResponseObject.self, from: data)
            return .Success(with: json)
        } catch {
            return .Failure(with: error.localizedDescription)
        }
    }
}
