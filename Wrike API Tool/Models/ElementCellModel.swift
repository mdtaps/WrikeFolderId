//
//  ElementCellModel.swift
//  Wrike API Tool
//
//  Created by Mark Tapia on 7/24/20.
//  Copyright © 2020 Mark Tapia. All rights reserved.
//

import Foundation
import UIKit

struct ElementCellModel {    
    func getAccountElementCell(for tableView: UITableView) -> AccountElementTableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "accountElementCell") as? AccountElementTableViewCell {
            return cell
        } else {
            return getCellFromNib()
        }
    }
    
    private func getCellFromNib() -> AccountElementTableViewCell {
        let cellNibName = "AccountElementTableViewCell"
         let nib = Bundle.main.loadNibNamed(cellNibName, owner: nil, options: nil)
         let cell = nib?.first! as! AccountElementTableViewCell
        return cell
    }
}
