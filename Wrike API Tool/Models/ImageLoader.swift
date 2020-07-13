//
//  ImageLoader.swift
//  Wrike API Tool
//
//  Created by Mark Tapia on 7/12/20.
//  Copyright © 2020 Mark Tapia. All rights reserved.
//

import Foundation
import UIKit

class ImageLoader {
    func downloadImage(from urlPath: String, completion: @escaping (UIImage) -> ()) {
        guard let url = URL(string: urlPath) else {
            DispatchQueue.main.async {
                completion(UIImage())
            }
            return
        }
        
        var data: Data
        
        do {
            data = try Data(contentsOf: url)
        } catch {
            DispatchQueue.main.async {
                completion(UIImage())
            }
            print(error)
            return
        }
        
        guard let image = UIImage(data: data) else {
            DispatchQueue.main.async {
                completion(UIImage())
            }
            return
        }
        
        DispatchQueue.main.async {
            completion(image)
        }
    }
}
