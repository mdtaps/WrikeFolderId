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
        
        guard let requestUrl = URL(string: "https://www.wrike.com/oauth2/authorize/v4?client_id=q96F3zIx&response_type=code") else {
            return
        }
        
        UIApplication.shared.open(requestUrl, options: [:], completionHandler: nil)
        
        
    }
    
    
}