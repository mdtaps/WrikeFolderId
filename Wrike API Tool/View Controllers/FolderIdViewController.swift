//
//  FolderIdViewController.swift
//  Wrike API Tool
//
//  Created by Mark Tapia on 7/16/19.
//  Copyright © 2019 Mark Tapia. All rights reserved.
//

import UIKit

@IBDesignable
class FolderIdViewController: UIViewController {
    
    @IBOutlet weak var copyButton: StyledButton!
    @IBOutlet weak var folderIdLabel: UILabel!
    
    var folderId: String
    
    init(folderId: String) {
        self.folderId = folderId
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        folderIdLabel.text = folderId
    }
    
    @IBAction func copyButtonPressed(_ sender: StyledButton) {
        UIPasteboard.general.string = folderId
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
}
