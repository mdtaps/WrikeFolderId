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
    var wrikeObjectObserver: NSKeyValueObservation?
    let defaults = UserDefaults.standard
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    @IBAction func loginButtonPressed(_ sender: StyledButton) {
        getWrikeFolderResponseObject()
    }
}

//MARK: Extensions
extension LoginViewController {
    private func getWrikeFolderResponseObject() {
        WrikeAPINetworkClient.shared.retrieveWrikeFolders(for: .GetAllFolders, returnType: WrikeAllFoldersResponseObject.self) { result in
            switch result {
            case .Failure(with: let failureString):
                //TODO: Display failure
                fatalError(failureString)
            case .Success(with: let object):
                DispatchQueue.main.async {
                    self.launchFolderView(using: object)
                }
            }
        }
    }
    
    private func launchFolderView(using wrikeObject: WrikeAllFoldersResponseObject) {
        guard let rootFolder = wrikeObject.data.first else {
            //TODO: Throw error
            fatalError("No folders found")
        }
        
        let vc = AccountElementsViewController(wrikeFolder: rootFolder)
        vc.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .done, target: vc, action: #selector(AccountElementsViewController.logout))
        
        let navController = UINavigationController(rootViewController: vc)
        navController.modalPresentationStyle = .fullScreen

        appDelegate?.wrikeObject = wrikeObject
        self.present(navController, animated: true, completion: nil)
    }
}


