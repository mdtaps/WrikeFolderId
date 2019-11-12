//
//  ViewController.swift
//  Wrike API Tool
//
//  Created by Mark Tapia on 6/21/19.
//  Copyright © 2019 Mark Tapia. All rights reserved.
//

import UIKit
import WebKit

@IBDesignable
class LoginViewController: UIViewController, WKUIDelegate {

    @IBOutlet weak var loginButton: StyledButton!
    @IBOutlet weak var webView: WKWebView!
    var authCodeObserver: NSKeyValueObservation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginButtonPressed(_ sender: StyledButton) {
        let requestUrl = getWrikeOAuthUrl()
        
        //Open URL to login to Wrike via OAuth, returns Authorization Code to AppDelegate
        //for use in token creation
        UIApplication.shared.open(requestUrl, options: [:], completionHandler: nil)
        
        //Set observer for authCode value in UserDefaults.
        //Closure runs request for Wrike token once value is set
        let defaults = UserDefaults.standard
                
        authCodeObserver = defaults.observe(\.authCode!) { (defaults, change) in
            guard defaults.authCode != nil else {
                print("No value set for UserDefault authCode")
                return
            }
            
            WrikeAuthNetworkingClient.shared.getAccessToken { result in
                switch result {
                case .Failure(with: let failureString):
                    print(failureString)
                case .Success(with: let accessTokenObject):
                    accessTokenObject.writeToDefaults()
                    
                    self.connectToWrike()
                }
            }
        }
    }
}

//MARK: Extensions
extension LoginViewController {
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
    
    func connectToWrike() {
        WrikeNetworkClient.shared.retrieveWrikeFolders { (result) in
            switch result {
            case .Failure(with: let failureString):
                //TODO: Display failure
                fatalError(failureString)
            case .Success(with: let object):
                guard let rootFolder = object.data.first else {
                    fatalError("No folders found")
                }

                DispatchQueue.main.async {
                    let vc = AccountElementsViewController(wrikeFolder: rootFolder)
                    vc.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .done, target: vc, action: #selector(AccountElementsViewController.logout))
                    
                    let navController = UINavigationController(rootViewController: vc)
                    navController.modalPresentationStyle = .fullScreen

                    let appDelegate = UIApplication.shared.delegate as? AppDelegate
                    appDelegate?.wrikeObject = object
                    self.present(navController, animated: true, completion: nil)
                }
            }
        }
    }
}


