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
    @IBOutlet weak var objectIdLabel: UILabel!
    @IBOutlet weak var objectTitleLabel: UILabel!
    @IBOutlet weak var idCopiedMessageLabel: UILabel!
    
    var wrikeObject: IdentifiableWrikeObject
    
    init(wrikeObject: IdentifiableWrikeObject) {
        self.wrikeObject = wrikeObject
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        objectIdLabel.text = wrikeObject.id
        objectTitleLabel.text = wrikeObject.title
    }
    
    @IBAction func copyButtonPressed(_ sender: StyledButton) {
        UIPasteboard.general.string = wrikeObject.id
        animateIdCopiedMessageLabel()
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    private func animateIdCopiedMessageLabel() {
        idCopiedMessageLabel.alpha = 1.0
        UIView.animate(withDuration: 0.5, delay: 0.75, animations: { self.idCopiedMessageLabel.alpha = 0.0 })
    }
    
}
