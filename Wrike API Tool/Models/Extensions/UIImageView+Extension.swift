//
//  UIImageView+Extension.swift
//  Wrike API Tool
//
//  Created by Mark Tapia on 6/7/21.
//  Copyright © 2021 Mark Tapia. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    func loadImage(at url: String) {
        if let urlFromString = URL(string: url) {
            loadImage(at: urlFromString)
        } else {
            //TODO: Display default image
            self.image = UIImage()
        }
    }
    
    func loadImage(at url: URL) {
        UIImageLoader.loader.load(from: url, for: self)
    }
    
    func cancelImageLoad() {
        UIImageLoader.loader.cancel(for: self)
    }
}
