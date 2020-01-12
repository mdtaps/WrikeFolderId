//
//  AccountElementsViewController.swift
//  Wrike API Tool
//
//  Created by Mark Tapia on 6/24/19.
//  Copyright © 2019 Mark Tapia. All rights reserved.
//

import UIKit

class AccountElementsViewController: UIViewController {
    //MARK: Outlets
    @IBOutlet weak var elementsTableView: UITableView!
    
    //MARK: Properties
    var parentFolder: FolderData
    var refreshDelegate: RefreshDelegate
    private let refreshControl = UIRefreshControl()
    lazy var childFolders: [FolderData] = {
        var folders = [FolderData]()

        if !parentFolder.childIds.isEmpty {
            for datum in appDelegate.wrikeObject!.data {
                if parentFolder.childIds.contains(datum.id) {
                    folders.append(datum)
                }
            }
        }
        
        return folders
    }()
    
    lazy var appDelegate = {
        UIApplication.shared.delegate as! AppDelegate
    }()
 
    //MARK: Initializers
    init(wrikeFolder: FolderData, refreshDelegate: RefreshDelegate) {
        self.refreshDelegate = refreshDelegate
        self.parentFolder = wrikeFolder
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        elementsTableView.delegate = self
        elementsTableView.dataSource = self
        
       if parentFolder.title == "Root" {
            title = "Home"
        } else {
            title = parentFolder.title
        }
        
        //Setting footerView keeps the table view from creating blank cells
        //when there are not enough cells to fill the screen
        elementsTableView.tableFooterView = UIView()
        
        elementsTableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshWrikeFolderData), for: .valueChanged)
    }
    
    //MARK: Functions
    @objc func logout() {
        clearUserDefaultsAuthData()
        dismiss(animated: true, completion: nil)
    }
}

//MARK: Table View Delegate & Data Source Functions
extension AccountElementsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parentFolder.childIds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let elementCell: AccountElementTableViewCell
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "accountElementCell") as? AccountElementTableViewCell {
            elementCell = cell
        } else {
            let cellNibName = "AccountElementTableViewCell"
            let nib = Bundle.main.loadNibNamed(cellNibName, owner: self, options: nil)
            elementCell = nib?.first! as! AccountElementTableViewCell
        }
        
        elementCell.delegate = self
        let currentFolder = childFolders[indexPath.row]
        
        elementCell.folderId = currentFolder.id

                
        if currentFolder.childIds.isEmpty {
            elementCell.caretButton.isHidden = true
            
        } else {
            elementCell.caretButton.isHidden = false
        }
        
        if currentFolder.project == nil {
            elementCell.clipboardImage.isHidden = true
        } else {
            elementCell.clipboardImage.isHidden = false
        }
        
        elementCell.elementTitleButton.setTitle(currentFolder.title, for: .normal)
        
        return elementCell
    }
}

extension AccountElementsViewController: CellClickDelegate {
    internal func launchFolderIdView(folderId: String) {
        let vc = FolderIdViewController(folderId: folderId)
        present(vc, animated: true, completion: nil)
    }
    
    //TODO: Use new childFolders array
    internal func loadChildFolders(folderId: String) {
        for folder in childFolders {
            if folder.id == folderId {
                if !folder.childIds.isEmpty {
                    let vc = AccountElementsViewController(wrikeFolder: folder, refreshDelegate: refreshDelegate)
                    navigationController?.pushViewController(vc, animated: true)
                }
                break
            }
        }
    }
    
    private func clearUserDefaultsAuthData() {
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
    }
    
     @objc private func refreshWrikeFolderData() {
        //TODO: Call refresh
        refreshDelegate.getWrikeFolders()
    }
}
