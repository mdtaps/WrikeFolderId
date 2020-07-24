//
//  SpacesViewController.swift
//  Wrike API Tool
//
//  Created by Mark Tapia on 5/3/20.
//  Copyright © 2020 Mark Tapia. All rights reserved.
//

import UIKit

class SpacesViewController: UIViewController {
    //MARK: Outlets
    @IBOutlet weak var spacesTableView: UITableView!
    
    let spaceObjects: [IdentifiableWrikeObject]
    let refreshDelegate: RefreshDelegate
    let imageLoader = ImageLoader()
    
    init(spaceObjects: [IdentifiableWrikeObject], refreshDelegate: RefreshDelegate) {
        self.spaceObjects = spaceObjects
        self.refreshDelegate = refreshDelegate
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        spacesTableView.delegate = self
        spacesTableView.dataSource = self
        
        //Setting footerView prevents the table view from creating blank cells
        //when there are not enough cells to fill the screen
        spacesTableView.tableFooterView = UIView()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .done, target: self, action: #selector(logout))
    }
    
    //MARK: Functions
    @objc func logout() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.clearUserDefaultsAuthData()
        dismiss(animated: true, completion: nil)
    }
}

extension SpacesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return spaceObjects.count
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
        
        if let currentSpaceObject = spaceObjects[indexPath.row] as? SpaceObject {
            elementCell.wrikeObject = currentSpaceObject
            elementCell.elementTitleButton.setTitle(currentSpaceObject.title, for: .normal)
            
            imageLoader.downloadImage(from: currentSpaceObject.avatarUrl) { image in
                elementCell.elementImage.image = image
                elementCell.elementImage.isHidden = false
            }

            return elementCell
            
        } else if let rootFolder = spaceObjects[indexPath.row] as? FolderData {
            elementCell.wrikeObject = rootFolder
            elementCell.elementImage.isHidden = true
            elementCell.elementTitleButton.setTitle("Shared With Me", for: .normal)
            return elementCell
        }
        
        return elementCell
    }
}

extension SpacesViewController: CellClickDelegate {
    internal func launchFolderIdView(wrikeObject: IdentifiableWrikeObject) {
        let vc = FolderIdViewController(wrikeObject: wrikeObject)
        present(vc, animated: true, completion: nil)
    }
    
    internal func loadChildFolders(wrikeObject: IdentifiableWrikeObject) {
        if wrikeObject.title == "Root" {
            WrikeAPINetworkClient.shared.retrieveWrikeData(for: .GetAllFolders,
                                                              returnType: WrikeAllFoldersResponseObject.self) { result in
                switch result {
                case .Failure(with: let failureString):
                    print("Get folder call failed with cause: \(failureString)")
                case .Success(with: let folderResponse):
                    self.loadChildren(from: folderResponse.data.first!.childIds, withParent: wrikeObject)
                }
            }
        } else {
            WrikeAPINetworkClient.shared.retrieveWrikeData(for: .GetFoldersFromSpaceId(spaceId: wrikeObject.id),
                                                              returnType: WrikeAllFoldersResponseObject.self) { result in
                switch result {
                case .Failure(with: let failureString):
                    print("Get folder call failed with cause: \(failureString)")
                case .Success(with: let folderResponse):
                    self.loadChildren(from: folderResponse.data.first!.childIds, withParent: wrikeObject)
                }
            }
        }
    }
    
    private func loadChildren(from folderIdArray: [String], withParent parentWrikeObject: IdentifiableWrikeObject) {
        //TODO: Break this into its own function
        let dispatchGroup = DispatchGroup()
        let childIdsSplitIntoGroupsOfOneHundred = folderIdArray.chunked(into: 100)
        var allWrikeFolders = [WrikeFolderObject]()
        
        for childIdGroup in childIdsSplitIntoGroupsOfOneHundred {
            dispatchGroup.enter()
            WrikeAPINetworkClient.shared.retrieveWrikeData(for: .GetFoldersFromListOfIds(idsArray: childIdGroup), returnType: WrikeFolderListResponseObject.self) { response in
                switch response {
                case .Failure(with: let failureString):
                    print("Get folders from list of ids failed with: \(failureString)")
                    dispatchGroup.leave()
                case .Success(with: let folderList):
                    allWrikeFolders.append(contentsOf: folderList.data)
                    dispatchGroup.leave()
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            self.presentFoldersList(from: allWrikeFolders, parentObject: parentWrikeObject)
        }
    }
    
    private func presentFoldersList(from childFolders: [IdentifiableWrikeObject],
                                    parentObject: IdentifiableWrikeObject) {
        let childFolders = childFolders as! [WrikeFolderObject]
        let vc = AccountElementsViewController(wrikeObjects: childFolders, parentObject: parentObject, refreshDelegate: self.refreshDelegate)
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
