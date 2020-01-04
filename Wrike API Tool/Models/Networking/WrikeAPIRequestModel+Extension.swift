//
//  WrikeAPIRequestModel+Extension.swift
//  Wrike API Tool
//
//  Created by Mark Tapia on 12/25/19.
//  Copyright © 2019 Mark Tapia. All rights reserved.
//

import Foundation

extension WrikeAPIRequestModel {
    static func getStringForUrlPath(using stringArray: [String]) -> String {
        var returnString = ""
        var counter = 1
        for element in stringArray {
            returnString += element
            if stringArray.count != counter {
                returnString += ","
                counter += 1
            }
        }
        return returnString
    }
}
