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
    private let refreshControl = UIRefreshControl()
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
        
       if wrikeFolder.title == "Root" {
            title = "Home"
        } else {
            title = wrikeFolder.title
        }
        
        //Setting footerView keeps the table view from creating blank cells
        //when there are only a few cells on the screen
        elementsTableView.tableFooterView = UIView()
        
        elementsTableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshWrikeFolderData), for: .valueChanged)
    }
    
    @objc func logout() {
        clearUserDefaultsAuthData()
        dismiss(animated: true, completion: nil)
    }
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
        
        elementCell.delegate = self
        
        elementCell.folderId = childIds[indexPath.row]
        var elementTitleText: String?
        
        for datum in appDelegate.wrikeObject!.data {
            if datum.id == elementCell.folderId {
                elementTitleText = datum.title
                
                if datum.childIds!.isEmpty {
                    elementCell.caretButton.isHidden = true
                }
                
                if datum.project == nil {
                    elementCell.clipboardImage.isHidden = true
                }
                break
            }
        }
        
        elementCell.elementTitleButton.setTitle(elementTitleText ?? "Unknown Title", for: .normal)
        
        return elementCell
    }
}

extension AccountElementsViewController: CellClickDelegate {
    internal func launchFolderIdView(folderId: String) {
        let vc = FolderIdViewController(folderId: folderId)
        present(vc, animated: true, completion: nil)
    }
    
    internal func loadChildFolders(folderId: String) {
        for folder in appDelegate.wrikeObject!.data {
            if folder.id == folderId {
                if !folder.childIds!.isEmpty {
                    let vc = AccountElementsViewController(wrikeFolder: folder)
                    navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    
    private func clearUserDefaultsAuthData() {
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
    }
    
     @objc private func refreshWrikeFolderData() {
        //TODO: Get Wrike data
        
        //TODO: Close table view to root
    }
}
