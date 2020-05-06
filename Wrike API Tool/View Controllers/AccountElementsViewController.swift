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
    var parentObject: FolderObject
    var wrikeObjects: [FolderObject]
    var refreshDelegate: RefreshDelegate
    let refreshControl = UIRefreshControl()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
 
    //MARK: Initializers
    init(wrikeObjects: [FolderObject], parentObject: FolderObject, refreshDelegate: RefreshDelegate) {
        self.refreshDelegate = refreshDelegate
        self.wrikeObjects = wrikeObjects
        self.parentObject = parentObject

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        elementsTableView.delegate = self
        elementsTableView.dataSource = self
                
        title = parentObject.title
        
        //Setting footerView prevents the table view from creating blank cells
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
        return wrikeObjects.count
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
        let currentFolder = wrikeObjects[indexPath.row]
        
        elementCell.folderObject = currentFolder

        if currentFolder.childIds.isEmpty {
            elementCell.caretButton.isHidden = true
        } else {
            elementCell.caretButton.isHidden = false
        }
        
        if currentFolder.project != nil {
            let image = UIImage(named: "clipboard")
            elementCell.imageView?.image = image
            elementCell.imageView?.isHidden = false
        } else {
            elementCell.imageView?.isHidden = true
        }
        
        elementCell.elementTitleButton.setTitle(currentFolder.title, for: .normal)
        
        return elementCell
    }
}

//Handling interaction with the elements in the cell
extension AccountElementsViewController: CellClickDelegate {
    internal func launchFolderIdView(folderObject: FolderObject) {
        let vc = FolderIdViewController(folderObject: folderObject)
        present(vc, animated: true, completion: nil)
    }
    
    internal func loadChildFolders(folderObject: FolderObject) {
        let childIds = folderObject.childIds
        WrikeAPINetworkClient.shared.retrieveWrikeFolders(for: .GetFoldersFromListOfIds(idsArray: childIds), returnType: WrikeFolderListResponseObject.self) { response in
            switch response {
            case .Failure(with: let failureString):
                print("Get folders from list of ids failed with: \(failureString)")
            case .Success(with: let folderList):
                print("Success!")
                dump(folderList)
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
