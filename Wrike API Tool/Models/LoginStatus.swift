//
//  LoginStatus.swift
//  Wrike API Tool
//
//  Created by Mark Tapia on 7/20/20.
//  Copyright © 2020 Mark Tapia. All rights reserved.
//

import UIKit

class LoginStatus {
    func viewShouldHide() -> Bool {
        return UserDefaults.standard.accessToken == nil
    }
    
    func setAccountTitle(completion: @escaping (_ accountName: String) -> Void ) {
        WrikeAPINetworkClient.shared.retrieveWrikeData(for: .GetAccountData, returnType: WrikeAccountResponseObject.self) { result in
            switch result {
            case .Failure(with: _):
                completion("Account Title Not Found")
            case .Success(with: let accountData):
                completion(accountData.data.first?.name ?? "Account Title Not Found")
            }
        }
    }
}
