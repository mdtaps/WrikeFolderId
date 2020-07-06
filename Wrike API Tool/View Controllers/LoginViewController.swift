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
        let dispatchGroup = DispatchGroup()
        var wrikeObjects = [IdentifiableWrikeObject]()
        
        dispatchGroup.enter()
        WrikeAPINetworkClient.shared.retrieveWrikeFolders(for: .GetSpaces, returnType: WrikeSpacesResponseObject.self) { result in
            switch result {
            case .Failure(with: let failureString):
                //TODO: Display failure
                fatalError(failureString)
            case .Success(with: let wrikeObject):
                wrikeObjects.append(contentsOf: wrikeObject.data)
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.enter()
        WrikeAPINetworkClient.shared.retrieveWrikeFolders(for: .GetAllFolders, returnType: WrikeAllFoldersResponseObject.self) { result in
            switch result {
            case .Failure(with: let failureString):
                fatalError(failureString)
            case .Success(with: let wrikeObject):
                wrikeObjects.append(wrikeObject.data.first!)
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            self.removeLoadingWheel()
            self.launchFolderView(using: wrikeObjects)
        }
    }
    
    private func launchFolderView(using spaceObjects: [IdentifiableWrikeObject]) {
        let vc = SpacesViewController(spaceObjects: spaceObjects, refreshDelegate: self)
        vc.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .done, target: vc, action: #selector(SpacesViewController.logout))
        
        mainNavigationController.viewControllers.removeAll()
        mainNavigationController.pushViewController(vc, animated: false)
        mainNavigationController.popToRootViewController(animated: false)

        if mainNavigationController.presentingViewController == nil {
            self.present(mainNavigationController, animated: true, completion: nil)
        }
        removeLoadingWheel()
    }
    
}

//Used for setting this VCs window as the anchor for the web auth window
extension LoginViewController: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return view.window!
    }
}


