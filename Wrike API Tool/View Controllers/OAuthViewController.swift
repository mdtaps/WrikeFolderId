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
        
        //Open URL to login to Wrike via OAuth, returns Authorization Code to AppDelegate
        //for use in token creation
        UIApplication.shared.open(requestUrl, options: [:], completionHandler: nil)
        
        //Set observer for authCode value in UserDefaults. Closure runs
        //request for Wrike token once value is set
        observer = UserDefaults.standard.observe(\.authCode, options:[.new]) { (defaults, change) in
            guard let authCode = defaults.authCode else {
                print("No value set for UserDefault authCode")
                return
            }
            
            //TODO: Call network request using authCode
        }
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
        
        queryItems.append(URLQueryItem(name: AccessTokenRequestParameters.Constants.Keys.ClientId,
                                       value: AccessTokenRequestParameters.Constants.Values.ClientId))
        queryItems.append(URLQueryItem(name: AccessTokenRequestParameters.Constants.Keys.Code,
                                       value: AccessTokenRequestParameters.Constants.Values.Code))
        queryItems.append(URLQueryItem(name: "redirect_uri", value: "https://mdtaps.com"))
        components.queryItems = queryItems
        
        return components.url!
    }
}
