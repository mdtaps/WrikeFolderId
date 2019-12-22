//
//  Extensions.swift
//  Wrike API Tool
//
//  Created by Mark Tapia on 7/12/19.
//  Copyright © 2019 Mark Tapia. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    class func fromNib<T: UIView>() -> T {
        let bundle = Bundle(for: self)
        let nibName = String(describing: self)
        let nib = UINib(nibName: nibName, bundle: bundle)
        
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? T else {
            fatalError("Error loading nib with name \(nibName)")
        }
        
        return view
    }
}

extension NSLayoutConstraint {
    override public var description: String {
        let id = identifier ?? ""
        return "id: \(id), constant: \(constant)"
    }
}
