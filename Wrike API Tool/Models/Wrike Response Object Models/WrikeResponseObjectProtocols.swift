//
//  WrikeResponseObjectProtocols.swift
//  Wrike API Tool
//
//  Created by Mark Tapia on 6/27/20.
//  Copyright © 2020 Mark Tapia. All rights reserved.
//

import Foundation
import UIKit

//Protocol used by all response objects to group
//them. For use in displaying and identifying.
protocol IdentifiableWrikeObject {
    var id: String { get }
    var title: String { get }
    func setImage(for imageView: UIImageView) -> Void
    func getChildObjects(completionHandler: @escaping ([IdentifiableWrikeObject]) -> Void)
}
