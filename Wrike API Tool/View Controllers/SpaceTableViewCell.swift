//
//  SpaceTableViewCell.swift
//  Wrike API Tool
//
//  Created by Mark Tapia on 4/25/20.
//  Copyright © 2020 Mark Tapia. All rights reserved.
//

import UIKit

class SpaceTableViewCell: UITableViewCell {

    @IBOutlet weak var spaceIconImage: UIImageView!
    @IBOutlet weak var spaceTitleButton: StyledButton!
    @IBOutlet weak var caretButton: StyledButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
