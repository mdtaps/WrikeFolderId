//
//  AccountElementTableViewCell.swift
//  Wrike API Tool
//
//  Created by Mark Tapia on 7/11/19.
//  Copyright © 2019 Mark Tapia. All rights reserved.
//

import UIKit

protocol CellClickDelegate {
    func launchFolderIdView(using wrikeObject: IdentifiableWrikeObject)
    func launchAccountElementView(using wrikeObject: IdentifiableWrikeObject)
}

class AccountElementTableViewCell: UITableViewCell {
    @IBOutlet weak var elementTitleButton: StyledButton!
    @IBOutlet weak var caretButton: StyledButton!
    @IBOutlet weak var elementImage: UIImageView!
    
    var onReuse: () -> Void = {}
    var delegate: CellClickDelegate?
    var wrikeObject: IdentifiableWrikeObject? {
        didSet {
            setTitleForElementTitleButton()
            setImageForElementImage()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        elementImage.image = nil
        elementImage.cancelImageLoad()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        
        caretButton.setTitle("\u{203A}", for: .normal)
    }
    
    @IBAction func elementTitleTapped(_ sender: UIButton) {
        if let wrikeObject = wrikeObject {
            delegate?.launchFolderIdView(using: wrikeObject)
        }
    }
    
    @IBAction func caretTapped(_ sender: UIButton) {
        if let wrikeObject = wrikeObject {
            delegate?.launchAccountElementView(using: wrikeObject)
        } 
    }
    
    func setTitleForElementTitleButton() {
        if wrikeObject?.title == "Root" {
                elementTitleButton.setTitle("Shared with Me", for: .normal)
        } else {
            elementTitleButton.setTitle(wrikeObject?.title, for: .normal)
        }
    }
    
    func setImageForElementImage() {
        
    }
}
