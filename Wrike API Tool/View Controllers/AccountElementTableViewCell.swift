//
//  AccountElementTableViewCell.swift
//  Wrike API Tool
//
//  Created by Mark Tapia on 7/11/19.
//  Copyright © 2019 Mark Tapia. All rights reserved.
//

import UIKit

protocol CellClickDelegate {
    func launchFolderIdView(wrikeObject: IdentifiableWrikeObject)
    func loadChildFolders(wrikeObject: IdentifiableWrikeObject)
}

class AccountElementTableViewCell: UITableViewCell {
    @IBOutlet weak var elementTitleButton: StyledButton!
    @IBOutlet weak var caretButton: StyledButton!
    @IBOutlet weak var elementImage: UIImageView!
    
    var delegate: CellClickDelegate?
    var wrikeObject: IdentifiableWrikeObject?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        
        caretButton.setTitle("\u{203A}", for: .normal)
    }
    
    @IBAction func elementTitleTapped(_ sender: UIButton) {
        //TODO: Make Get Folder call
        if let wrikeObject = wrikeObject {
            delegate?.launchFolderIdView(wrikeObject: wrikeObject)
        }
    }
    
    @IBAction func caretTapped(_ sender: UIButton) {
        if let wrikeObject = wrikeObject {
            delegate?.loadChildFolders(wrikeObject: wrikeObject)
        } 
    }
}
