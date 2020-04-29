//
//  AccountElementTableViewCell.swift
//  Wrike API Tool
//
//  Created by Mark Tapia on 7/11/19.
//  Copyright © 2019 Mark Tapia. All rights reserved.
//

import UIKit

protocol CellClickDelegate {
    func launchFolderIdView(folderId: String)
    func loadChildFolders(folderId: String)
}

class AccountElementTableViewCell: UITableViewCell {
    @IBOutlet weak var elementTitleButton: StyledButton!
    @IBOutlet weak var caretButton: StyledButton!
    @IBOutlet weak var clipboardImage: UIImageView!
    
    var delegate: CellClickDelegate?
    var folderId: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        
        caretButton.setTitle("\u{203A}", for: .normal)
    }
    
    @IBAction func elementTitleTapped(_ sender: UIButton) {
        //TODO: Make Get Folder call
        if let folderId = folderId {
            delegate?.launchFolderIdView(folderId: folderId)
        }
    }
    
    @IBAction func caretTapped(_ sender: UIButton) {
        if let folderId = folderId {
            delegate?.loadChildFolders(folderId: folderId)
        }
    }
}
