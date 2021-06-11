//  Borrowed from https://www.donnywals.com/efficiently-loading-images-in-table-views-and-collection-views/
//  ImageLoader.swift
//  Wrike API Tool
//
//  Created by Mark Tapia on 7/12/20.
//  Copyright © 2020 Mark Tapia. All rights reserved.
//

import Foundation
import UIKit

class ImageLoader {
    private var loadedImages = [URL: UIImage]()
    private var runningRequests = [UUID: URLSessionDataTask]()
    
    func loadImage(_ url: URL, _ completion: @escaping (Result<UIImage>) -> Void) -> UUID? {
        if let image = loadedImages[url] {
            completion(.Success(with: image))
            return nil
        }

        let uuid = UUID()

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            defer {self.runningRequests.removeValue(forKey: uuid) }

            if let error = error {
                completion(.Failure(with: error.localizedDescription))
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.Failure(with: "No response from server"))
                return
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                completion(.Failure(with: "Auth Request Invalid, status code of \(httpResponse.statusCode), \(HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode))"))
                return
            }

            if let data = data, let image = UIImage(data: data) {
              self.loadedImages[url] = image
                completion(.Success(with: image))
              return
            }
        }
        
        task.resume()

        runningRequests[uuid] = task
        return uuid
    }
    
    func cancelLoad(_ uuid: UUID) {
        runningRequests[uuid]?.cancel()
        runningRequests.removeValue(forKey: uuid)
    }
}
