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

        connectToWrike()
        
        //Will be used when using OAuth
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "oauthViewController") as! OAuthViewController
//        self.show(vc, sender: self)
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
                    let appDelegate = UIApplication.shared.delegate as? AppDelegate
                    appDelegate?.wrikeObject = object
                    self.present(vc, animated: true, completion: nil)
                }
            }
        }
    }
    
}

