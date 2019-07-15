//
//  WrikeNetworkingClient.swift
//  Wrike API Tool
//
//  Created by Mark Tapia on 7/2/19.
//  Copyright © 2019 Mark Tapia. All rights reserved.
//

import Foundation

class WrikeNetworkClient {
    
    static let shared = WrikeNetworkClient()
    
    private init() {}
    
    func wrikeGETRequest(_ completion: @escaping (_ requestResult: Result<Data>) -> Void) {
        let urlString = "https://www.wrike.com/api/v4/folders"
        let url = URL(string: urlString)!

        let urlRequest = makeURLRequest(using: url)
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                completion(.Failure(with: error.localizedDescription))
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.Failure(with: "No response from server"))
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                completion(.Failure(with: "Invalid, Status Code of \(httpResponse.statusCode)"))
                return
            }
            
            if let data = data {
                completion(.Success(with: data))
            } else {
                completion(.Failure(with: "No data"))
            }
        }
        
        task.resume()
    }
    

    
    private func makeURLRequest(using url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let headerFields = ["Authorization":"bearer eyJ0dCI6InAiLCJhbGciOiJIUzI1NiIsInR2IjoiMSJ9.eyJkIjoie1wiYVwiOjI3ODA0MzgsXCJpXCI6NjMyNzAxNyxcImNcIjo0NjEyMDU2LFwidVwiOjU4NzI2MDgsXCJyXCI6XCJVU1wiLFwic1wiOltcIldcIixcIkZcIixcIklcIixcIlVcIixcIktcIixcIkNcIixcIkFcIixcIkxcIl0sXCJ6XCI6W10sXCJ0XCI6MH0iLCJpYXQiOjE1NjE2NTQ1NDJ9.SzKilwHKIEwcEbkOfBLLfv5Sd5bO-x9hBUAnAEM9Jtw","Accept":"*/*"]
        request.allHTTPHeaderFields = headerFields
        
        return request
    }
}

public enum Result<T> {
    case Success(with: T)
    case Failure(with: String)
}
