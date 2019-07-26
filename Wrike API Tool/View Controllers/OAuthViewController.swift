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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let urlString = "\"https://mdtaps.com\"".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        
        guard let requestUrl = URL(string: "https://www.wrike.com/oauth2/authorize/v4?client_id=m3jEarPA&response_type=code&redirect_uri=https://mdtaps.com") else {
            return
        }
        
        print(requestUrl.absoluteString)
        
        UIApplication.shared.open(requestUrl, options: [:], completionHandler: nil)
        
        
    }
    
    
}
