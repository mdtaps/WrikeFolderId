//
//  ViewController.swift
//  Wrike API Tool
//
//  Created by Mark Tapia on 6/21/19.
//  Copyright © 2019 Mark Tapia. All rights reserved.
//

import UIKit
import WebKit
import AuthenticationServices

protocol RefreshDelegate {
    func getWrikeFolders()
}

@IBDesignable
class LoginViewController: UIViewController, WKUIDelegate {
    override func viewDidLoad() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.loginDelegate = self
    }
    
    //MARK: Properties
    var mainNavigationController = FoldersNavigationController()
    
    //MARK: Outlets
    @IBOutlet weak var loginButton: StyledButton!
    
    //MARK: Actions
    @IBAction func loginButtonPressed(_ sender: StyledButton) {
        getWrikeFolders()
    }
}

//MARK: Extensions
extension LoginViewController: RefreshDelegate {
    func getWrikeFolders() {
        addLoadingWheel()
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
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        appDelegate.wrikeObject = wrikeObject

        guard let rootFolder = wrikeObject.data.first else {
            //TODO: Throw error
            fatalError("No folders found")
        }
        
        let vc = AccountElementsViewController(wrikeFolder: rootFolder, refreshDelegate: self)
        vc.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .done, target: vc, action: #selector(AccountElementsViewController.logout))
        
        //TODO: Why is this here?
        mainNavigationController.viewControllers.removeAll()
        mainNavigationController.pushViewController(vc, animated: false)
        mainNavigationController.popToRootViewController(animated: false)

        if mainNavigationController.presentingViewController == nil {
            self.present(mainNavigationController, animated: true, completion: nil)
        }
        removeLoadingWheel()
    }
}

extension LoginViewController: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return view.window!
    }
}


