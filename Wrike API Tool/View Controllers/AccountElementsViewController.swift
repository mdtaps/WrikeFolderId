//
//  AccountElementsViewController.swift
//  Wrike API Tool
//
//  Created by Mark Tapia on 6/24/19.
//  Copyright © 2019 Mark Tapia. All rights reserved.
//

import UIKit

class AccountElementsViewController: UIViewController {

    @IBOutlet weak var elementsTableView: UITableView!
    var wrikeFolder: FolderData
    lazy var appDelegate = {
        return UIApplication.shared.delegate as! AppDelegate
    }()
 
    init(wrikeFolder: FolderData) {
        self.wrikeFolder = wrikeFolder
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        elementsTableView.delegate = self
        elementsTableView.dataSource = self
        
    }
    
//    func getTitles(ids: [String]) -> [String] {
//        var titleStrings = [String]()
//        for id in ids {
//            titleStrings.append(getTitle(with: id))
//        }
//
//        return titleStrings
//    }
//
//    func getTitle(with id: String) -> String {
//        for datum in wrikeFolder.data {
//            if datum.id == id {
//                return datum.title
//            }
//        }
//
//        return ""
//    }
}

extension AccountElementsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wrikeFolder.childIds?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let childIds = wrikeFolder.childIds else {
            return UITableViewCell()
        }
        
        let elementCell: AccountElementTableViewCell
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "accountElementCell") as? AccountElementTableViewCell {
            elementCell = cell
        } else {
            let cellNibName = "AccountElementTableViewCell"
            let nib = Bundle.main.loadNibNamed(cellNibName, owner: self, options: nil)
            elementCell = nib?.first! as! AccountElementTableViewCell
        }
        
        let childId = childIds[indexPath.row]
        var elementTitleText: String?
        
        for datum in appDelegate.wrikeObject!.data {
            if datum.id == childId {
                elementTitleText = datum.title
                break
            }
        }
        
        elementCell.elementTitle.text = elementTitleText ?? "Unknown Title"
        
        return elementCell
    }
}
