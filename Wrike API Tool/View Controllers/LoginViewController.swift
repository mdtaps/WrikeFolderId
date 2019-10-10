//
//  ViewController.swift
//  Wrike API Tool
//
//  Created by Mark Tapia on 6/21/19.
//  Copyright © 2019 Mark Tapia. All rights reserved.
//

import UIKit

@IBDesignable
class LoginViewController: UIViewController {

    @IBOutlet weak var loginButton: StyledButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
    }
    
    @IBAction func loginButtonPressed(_ sender: StyledButton) {

//        connectToWrike()
        
        //Will be used when using OAuth
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "oauthViewController") as! OAuthViewController
        self.show(vc, sender: self)
    }
}

