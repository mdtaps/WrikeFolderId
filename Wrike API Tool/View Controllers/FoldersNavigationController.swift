//
//  FoldersNavigationController.swift
//  Wrike API Tool
//
//  Created by Mark Tapia on 1/12/20.
//  Copyright © 2020 Mark Tapia. All rights reserved.
//

import UIKit

class FoldersNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.modalPresentationStyle = .fullScreen
    }
    
    func resetNavController(to newRootViewController: SpacesViewController) {
        self.viewControllers.removeAll()
        self.pushViewController(newRootViewController, animated: false)
        self.popToRootViewController(animated: false)
    }
}
