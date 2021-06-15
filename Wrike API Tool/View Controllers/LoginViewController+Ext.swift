//
//  LoginViewController+Ext.swift
//  Wrike API Tool
//
//  Created by Mark Tapia on 7/24/20.
//  Copyright © 2020 Mark Tapia. All rights reserved.
//

import Foundation
import UIKit
import AuthenticationServices


//MARK: Extensions
extension LoginViewController {
    internal func setLoginMessage() {
        loginStatus.setAccountTitle { accountName in
            DispatchQueue.main.async {
                self.accountTitleLabel.text = accountName
            }
        }
    }
    
    internal func setViewVisibility() {
        loggedInLabel.isHidden = loginStatus.viewShouldHide()
        accountTitleLabel.isHidden = loginStatus.viewShouldHide()
        logoutButton.isHidden = loginStatus.viewShouldHide()
    }
}

extension LoginViewController: RefreshDelegate {
    func loginToWrike() {
        addLoadingWheel()
        
        let login = LoginModel(folderViewLaunch: launchFolderView(using:))
        login.gatherWrikeSpacesandTriggerLaunch()
    }
    
    private func launchFolderView(using spaceObjects: [IdentifiableWrikeObject]) {
        let accountElementViewModel = AccountElementViewModel(accountElements: spaceObjects,
                                                               refreshDelegate: self,
                                                               title: "Spaces")
        DispatchQueue.main.async {
            self.removeLoadingWheel()
            let vc = AccountElementsViewController(accountElementViewModel: accountElementViewModel)
            self.mainNavigationController.resetNavController(to: vc)
            
            //To handle when function is called from outside view controllers
            //and main nav controller is already presented
            if self.mainNavigationController.presentingViewController == nil {
                self.present(self.mainNavigationController, animated: true, completion: self.removeLoadingWheel)
            }
        }
    }
}

//Used for setting this VCs window as the anchor for the web auth window
extension LoginViewController: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.window!
    }
}
