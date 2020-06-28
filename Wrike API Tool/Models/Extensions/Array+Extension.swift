//
//  Array+Extension.swift
//  Wrike API Tool
//
//  Created by Mark Tapia on 6/27/20.
//  Copyright © 2020 Mark Tapia. All rights reserved.
//

import Foundation
//Code borrowed from https://www.hackingwithswift.com/example-code/language/how-to-split-an-array-into-chunks
extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
