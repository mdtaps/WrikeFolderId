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
    func loginToWrike()
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
        loginToWrike()
    }
}

//MARK: Extensions
extension LoginViewController: RefreshDelegate {
    func loginToWrike() {
        addLoadingWheel()
        
        let login = LoginModel(folderViewLaunch: launchFolderView(using:))
        login.gatherWrikeSpacesandTriggerLaunch()
    }
    
    private func launchFolderView(using spaceObjects: [IdentifiableWrikeObject]) {
        DispatchQueue.main.async {
            let vc = SpacesViewController(spaceObjects: spaceObjects, refreshDelegate: self)
            vc.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .done, target: vc, action: #selector(SpacesViewController.logout))
            
            self.mainNavigationController.viewControllers.removeAll()
            self.mainNavigationController.pushViewController(vc, animated: false)
            self.mainNavigationController.popToRootViewController(animated: false)

            if self.mainNavigationController.presentingViewController == nil {
                self.present(self.mainNavigationController, animated: true, completion: nil)
            }
            self.removeLoadingWheel()
        }
    }
}

//Used for setting this VCs window as the anchor for the web auth window
extension LoginViewController: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return view.window!
    }
}


