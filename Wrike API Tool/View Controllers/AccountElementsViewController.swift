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
    let wrikeObjectLoader = WrikeObjectLoader()
    let accountElementViewModel: AccountElementViewModel
    let refreshControl = UIRefreshControl()
 
    //MARK: Initializers
    init(accountElementViewModel: AccountElementViewModel) {
        self.accountElementViewModel = accountElementViewModel

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        elementsTableView.delegate = self
        elementsTableView.dataSource = self
                
        title = accountElementViewModel.title
        addLogoutButtonToBar()
        
        //Setting footerView prevents the table view from creating blank cells
        //when there are not enough cells to fill the screen
        
        //TODO: Set up an ElementsTableViewController file to handle this
        elementsTableView.tableFooterView = UIView()
        
        elementsTableView.refreshControl = refreshControl
        //TODO: See if I can call straight to the delegate
        refreshControl.addTarget(self, action: #selector(refreshWrikeFolderData), for: .valueChanged)
    }
}

//MARK: Table View Delegate & Data Source Functions
extension AccountElementsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accountElementViewModel.accountElements.count
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
        let currentFolder = accountElementViewModel.accountElements[indexPath.row]
        
        elementCell.wrikeObject = currentFolder
        elementCell.elementTitleButton.setTitle(currentFolder.title, for: .normal)
        currentFolder.setImage(for: elementCell.elementImage)
        
        return elementCell
    }
}

extension AccountElementsViewController {
    @objc func logout() {
        appDelegate.clearUserDefaultsAuthData()
        dismiss(animated: true, completion: nil)
    }
    
    private func addLogoutButtonToBar() {
        let logoutButton = UIBarButtonItem(title: "Logout", style: .done, target: self, action: #selector(logout) )
        self.navigationItem.rightBarButtonItem = logoutButton
    }
}

//Handling interaction with the elements in the cell
extension AccountElementsViewController: CellClickDelegate {
    internal func launchFolderIdView(using wrikeObject: IdentifiableWrikeObject) {
        let vc = FolderIdViewController(wrikeObject: wrikeObject)
        present(vc, animated: true, completion: nil)
    }
    
    internal func launchAccountElementView(using wrikeObject: IdentifiableWrikeObject) {
        wrikeObject.getChildObjects { wrikeChildObjects in
            DispatchQueue.main.async {

                let nextAccountElementViewModel = AccountElementViewModel(accountElements: wrikeChildObjects,
                                                                      refreshDelegate: self.accountElementViewModel.refreshDelegate,
                                                                      title: wrikeObject.title)
                let vc = AccountElementsViewController(accountElementViewModel: nextAccountElementViewModel)
            //TODO: Remove dependency on navigation Controller
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
     @objc private func refreshWrikeFolderData() {
        DispatchQueue.main.async {
            self.accountElementViewModel.refreshDelegate.loginToWrike()
        }
    }
}
