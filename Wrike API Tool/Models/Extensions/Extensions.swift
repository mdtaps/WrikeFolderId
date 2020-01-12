//
//  Extensions.swift
//  Wrike API Tool
//
//  Created by Mark Tapia on 7/12/19.
//  Copyright © 2019 Mark Tapia. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func addLoadingWheel() {
        let child = ActivityIndicatorViewController()

        // add the spinner view controller
        addChild(child)
        child.view.frame = view.frame
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }
    
    func removeLoadingWheel() {
        for child in self.children {
            if child is ActivityIndicatorViewController {
                child.willMove(toParent: nil)
                child.view.removeFromSuperview()
                child.removeFromParent()
            }
        }
    }
}

//Extension for custom description on layour warnings in console
extension NSLayoutConstraint {
    override public var description: String {
        let id = identifier ?? ""
        return "id: \(id), constant: \(constant)"
    }
}
