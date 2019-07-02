//
//  AccountElementsViewController.swift
//  Wrike API Tool
//
//  Created by Mark Tapia on 6/24/19.
//  Copyright © 2019 Mark Tapia. All rights reserved.
//

import UIKit

class AccountElementsViewController: UIViewController {

    @IBOutlet weak var elementsTableView: UITableView!
    
    var wrikeObject: WrikeResponseObjectModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        elementsTableView.delegate = self
        elementsTableView.dataSource = self
        
        connectToWrike()
    }
    
    func connectToWrike() {
        let urlString = "https://www.wrike.com/api/v4/folders"
        let url = URL(string: urlString)!
        print(url.absoluteString)
        let urlRequest = makeURLRequest(using: url)
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                self.outputResponse(response: .Failure(with: error.localizedDescription))
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                self.outputResponse(response: .Failure(with: "No response from server"))
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                self.outputResponse(response: .Failure(with: "Invalid, Status Code of \(httpResponse.statusCode)"))
                    return
            }
            
            if let data = data {
                self.outputResponse(response: .Success(with: data))
            } else {
                self.outputResponse(response: .Failure(with: "No data"))
            }
        }
        
        task.resume()
    }
    
    func outputResponse(response: Result<Data>) {
        switch response {
        case .Failure(with: let errorString):
            print(errorString)
        case .Success(with: let data):
            decodeJsonData(with: data)
        }
    }
    
    func decodeJsonData(with data: Data) {
        let decoder = JSONDecoder()
        
        do {
            let jsonResponse = try decoder.decode(WrikeResponseObjectModel.self, from: data)
            wrikeObject = jsonResponse
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func makeURLRequest(using url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let headerFields = ["Authorization":"bearer eyJ0dCI6InAiLCJhbGciOiJIUzI1NiIsInR2IjoiMSJ9.eyJkIjoie1wiYVwiOjI3ODA0MzgsXCJpXCI6NjMyNzAxNyxcImNcIjo0NjEyMDU2LFwidVwiOjU4NzI2MDgsXCJyXCI6XCJVU1wiLFwic1wiOltcIldcIixcIkZcIixcIklcIixcIlVcIixcIktcIixcIkNcIixcIkFcIixcIkxcIl0sXCJ6XCI6W10sXCJ0XCI6MH0iLCJpYXQiOjE1NjE2NTQ1NDJ9.SzKilwHKIEwcEbkOfBLLfv5Sd5bO-x9hBUAnAEM9Jtw","Accept":"*/*"]
        request.allHTTPHeaderFields = headerFields
        
        return request
    }

}

extension AccountElementsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

public enum Result<T> {
    case Success(with: T)
    case Failure(with: String)
}
