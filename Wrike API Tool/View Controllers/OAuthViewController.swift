//
//  OAuthViewController.swift
//  Wrike API Tool
//
//  Created by Mark Tapia on 6/21/19.
//  Copyright © 2019 Mark Tapia. All rights reserved.
//

import UIKit
import WebKit

class OAuthViewController: UIViewController, WKUIDelegate {
    @IBOutlet weak var webView: WKWebView!
    var observer: NSKeyValueObservation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let requestUrl = getWrikeOAuthUrl()
        
        //Set observer for authCode value in UserDefaults. Closure runs
        //request for Wrike token once value is set
        
        let defaults = UserDefaults.standard
        
//        defaults.set("", forKey: "authCode")
        
        observer = defaults.observe(\.authCode!) { (defaults, change) in
            guard let authCode = defaults.authCode else {
                print("No value set for UserDefault authCode")
                return
            }
            
            WrikeAuthNetworkingClient.shared.getAccessToken { result in
                switch result {
                case .Failure(with: let failureString):
                    print(failureString)
                case .Success(with: let accessTokenObject):
                    print(accessTokenObject)
                }
            }
        }
        
        //Open URL to login to Wrike via OAuth, returns Authorization Code to AppDelegate
        //for use in token creation
        UIApplication.shared.open(requestUrl, options: [:], completionHandler: nil)
    }
}

//MARK: Extensions
extension OAuthViewController {
    func getWrikeOAuthUrl() -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "wrike.com"
        components.path = "/oauth2/authorize/v4"
        var queryItems = [URLQueryItem]()
        
        queryItems.append(URLQueryItem(name: AuthorizationCodeRequest.Constants.Keys.ClientId,
                                       value: AuthorizationCodeRequest.Constants.Values.ClientId))
        queryItems.append(URLQueryItem(name: AuthorizationCodeRequest.Constants.Keys.ResponseType,
                                       value: AuthorizationCodeRequest.Constants.Values.ResponseType))
        queryItems.append(URLQueryItem(name: AuthorizationCodeRequest.Constants.Keys.RedirectUri, value: AuthorizationCodeRequest.Constants.Values.RedirectUri))
        components.queryItems = queryItems
        
        return components.url!
    }
}
