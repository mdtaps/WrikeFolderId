//
//  AppDelegate.swift
//  Wrike API Tool
//
//  Created by Mark Tapia on 6/21/19.
//  Copyright © 2019 Mark Tapia. All rights reserved.
//

import UIKit
import AuthenticationServices

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var wrikeObject: WrikeAllFoldersResponseObject?
    var loginDelegate: LoginViewController?
    var webAuthSession: ASWebAuthenticationSession?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        // Determine who sent the URL
        let sendingAppID = options[.sourceApplication]
        print("source application = \(sendingAppID ?? "Unknown")")
        
        // Process the URL
        guard let components = NSURLComponents(url: url, resolvingAgainstBaseURL: true),
            let oauthPath = components.path,
            let params = components.queryItems else {
                print("Invalid URL or oauth path missing")
                return false
        }
        
        if let code = params.first(where: { $0.name == "code" })?.value {
            print("oauthPath = \(oauthPath)")
            print("code = \(code)")
            return true
        } else {
            print("Token missing")
            return false
        }
    }
    
    //Handling Web to App handoff when login authorization has finished
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        
        var authCode: String?
        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb else {
            fatalError("User Activity Type in continueUserActivity, \(userActivity.activityType), is incorrect")
        }
        
        guard let incomingURL = userActivity.webpageURL else {
            fatalError("Incoming URL is null in continueUserActivity")
        }
        
        guard let components = NSURLComponents(url: incomingURL, resolvingAgainstBaseURL: true) else {
            fatalError("No components returned in URL from continueUserActivity")
        }
        
        guard let params = components.queryItems else {
            fatalError("No query items returned")
        }
               
        for param in params {
            if param.name == "code" {
                authCode = param.value!
            }
        }
                
        guard authCode != nil else {
            fatalError("No value set for Auth Code in AppDelegate")
        }
        
        //Cancel ASWebAuthenticationSession after successfully receiving auth code.
        //Necessary to handle here when redirect URL uses HTTPS protocol
        //instead of the session closure.
        webAuthSession?.cancel()
        let defaults = UserDefaults.standard
        defaults.set(authCode, forKey: "authCode")
                
        return true
     }
    
    func clearUserDefaultsAuthData() {
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
    }
}

