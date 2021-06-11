//  Borrowed from https://www.donnywals.com/efficiently-loading-images-in-table-views-and-collection-views/
//
//  UIImageLoader.swift
//  Wrike API Tool
//
//  Created by Mark Tapia on 6/7/21.
//  Copyright © 2021 Mark Tapia. All rights reserved.
//

import Foundation
import UIKit

class UIImageLoader {
    static let loader = UIImageLoader()
    
    private let imageLoader = ImageLoader()
    private var uuidMap = [UIImageView: UUID]()

    private init() {}
    
    func load(from url: String, for imageView: UIImageView) {
        if let urlFromString = URL(string: url) {
            load(from: urlFromString, for: imageView)
        } else {
            //TODO: Display default image
            imageView.image = UIImage()
        }
    }

    func load(from url: URL, for imageView: UIImageView) {
        let runningTaskId = imageLoader.loadImage(url) { result in
        
            defer { self.uuidMap.removeValue(forKey: imageView) }
            
            switch result {
            case .Success(with: let image):
                DispatchQueue.main.async {
                    imageView.image = image
                }
            case .Failure(with: let errorString):
                print(errorString)
                //TODO: Handle error
            }
      }

      if let runningTaskId = runningTaskId {
        uuidMap[imageView] = runningTaskId
      }
    }

    func cancel(for imageView: UIImageView) {
        if let uuid = uuidMap[imageView] {
            imageLoader.cancelLoad(uuid)
            uuidMap.removeValue(forKey: imageView)
        }
    }
}
