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
        appDelegate.loginDelegate = self
        setViewVisibility()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setViewVisibility()
        setLoginMessage()
    }
    
    //MARK: Properties
    var mainNavigationController = FoldersNavigationController()
    let loginStatus = LoginStatus()

    //MARK: Outlets
    @IBOutlet weak var loginButton: StyledButton!
    @IBOutlet weak var loggedInLabel: UILabel!
    @IBOutlet weak var accountTitleLabel: UILabel!
    @IBOutlet weak var logoutButton: UIButton!
    
    //MARK: Actions
    @IBAction func loginButtonPressed(_ sender: StyledButton) {
        loginToWrike()
    }
    
    @IBAction func logoutButtonPressed(_ sender: UIButton) {
        appDelegate.clearUserDefaultsAuthData()
        setViewVisibility()
    }
}


