//
//  ElementViewModel.swift
//  Wrike API Tool
//
//  Created by Mark Tapia on 6/3/21.
//  Copyright © 2021 Mark Tapia. All rights reserved.
//

import Foundation

struct AccountElementViewModel {
    let accountElements: [IdentifiableWrikeObject]
    let refreshDelegate: RefreshDelegate
    let title: String
    
    init(accountElements: [IdentifiableWrikeObject],
         refreshDelegate: RefreshDelegate,
         title: String) {
        self.accountElements = accountElements
        self.refreshDelegate = refreshDelegate
        self.title = title
    }
}
