//
//  AppDelegate.swift
//  Wrike API Tool
//
//  Created by Mark Tapia on 6/21/19.
//  Copyright © 2019 Mark Tapia. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

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
}

