//
//  WrikeLoginProcess.swift
//  Wrike API Tool
//
//  Created by Mark Tapia on 12/11/19.
//  Copyright © 2019 Mark Tapia. All rights reserved.
//

import Foundation
//TODO: Figure out which part of UIKit to import
import UIKit
import AuthenticationServices

class WrikeLoginProcess {
    static let shared = WrikeLoginProcess()
    
    private init() {}
    
    var authCodeObserver: NSKeyValueObservation?
    
    func loginToWrike(_ completion: @escaping (_ tokenIsSet: Bool) -> Void) {
        let tokenStatus = getTokenStatus()
        
        switch tokenStatus {
        case .TokenReady:
            completion(true)
        case .TokenNeedsRefresh:
            setLoginToken(using: .refreshToken) { result in
                completion(true)
            }
        case .NoAccessToken:
            //Set observer for authCode value in UserDefaults.
            //Closure runs request for Wrike token once value is set
            let defaults = UserDefaults.standard
                    
            authCodeObserver = defaults.observe(\.authCode!) { (defaults, _) in
                guard defaults.authCode != nil else {
                    print("No value set for UserDefault authCode")
                    return
                }
                
                self.setLoginToken(using: .authorizationCode) { result in
                    completion(true)
                }
            }
            
            let requestUrl = getWrikeOAuthUrl()
            print("Request URL: \(requestUrl)")
            
            // Use the URL and callback scheme specified by the authorization provider.
            let scheme = AuthorizationCodeRequest.Constants.Values.RedirectUri

            // Initialize the session.
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.session = ASWebAuthenticationSession(url: requestUrl, callbackURLScheme: scheme) { callbackURL, error in
                //TODO: Handle error
                print("callback called")
                guard error == nil, let callbackURL = callbackURL else { return }
                
                print(callbackURL.absoluteString)

                let queryItems = URLComponents(string: callbackURL.absoluteString)?.queryItems
                let code = queryItems?.filter({ $0.name == "code" }).first?.value
                
                let defaults = UserDefaults.standard
                defaults.set(code, forKey: "authCode")
            }
            appDelegate.session?.presentationContextProvider = appDelegate.loginDelegate

            appDelegate.session?.start()
            
            //TODO: Remove
            //Open URL to login to Wrike via OAuth, returns Authorization Code to AppDelegate
            //for use in token creation
            //UIApplication.shared.open(requestUrl, options: [:], completionHandler: nil)
        }
    }
    
    private func getWrikeOAuthUrl() -> URL {
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
    
    private func setLoginToken(using requestType: AuthorizationRequestType, completion: @escaping (_ result: Bool) -> Void) {
        WrikeAuthNetworkingClient.shared.getAccessToken(requestType: requestType) { result in
            switch result {
            case .Failure(with: let failureString):
                completion(false)
            case .Success(with: let accessTokenObject):
                accessTokenObject.writeToDefaults()
                completion(true)
            }
        }
    }
    
    private func getTokenStatus() -> TokenStatus {
        let defaults = UserDefaults.standard

        guard defaults.accessToken != nil else {
            return .NoAccessToken
        }
        
        let expirationTime = defaults.double(forKey: "expirationTime")
        let currentTime = Date().timeIntervalSince1970
        
        guard currentTime < expirationTime else {
            return .TokenNeedsRefresh
        }
        
        return .TokenReady
    }
    
    enum TokenStatus {
        case NoAccessToken
        case TokenNeedsRefresh
        case TokenReady
    }
}
