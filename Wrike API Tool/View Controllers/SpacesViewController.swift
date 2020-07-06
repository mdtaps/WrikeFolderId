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
        //Add 1 for Shared With Me cell
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
        
        print(indexPath.row)
        if let currentSpaceObject = spaceObjects[indexPath.row] as? SpaceObject {
            elementCell.wrikeObject = currentSpaceObject
             
            elementCell.elementTitleButton.setTitle(currentSpaceObject.title, for: .normal)
            do {
             //TODO: Turn this into an external function
             let imageUrl = URL(string: currentSpaceObject.avatarUrl)!
             let data = try Data(contentsOf: imageUrl)
             let image = UIImage(data: data)!
             
             elementCell.elementImage.image = image
             elementCell.elementImage.isHidden = false
            } catch {
             elementCell.elementImage.isHidden = true
            }

            return elementCell
            
        } else {
            elementCell.elementTitleButton.setTitle("Shared With Me", for: .normal)
            return elementCell
        }
    }
}

extension SpacesViewController: CellClickDelegate {
    internal func launchFolderIdView(wrikeObject: IdentifiableWrikeObject) {
        let vc = FolderIdViewController(wrikeObject: wrikeObject)
        present(vc, animated: true, completion: nil)
    }
    
    internal func loadChildFolders(wrikeObject: IdentifiableWrikeObject) {
        let spaceId = wrikeObject.id
        WrikeAPINetworkClient.shared.retrieveWrikeFolders(for: .GetFoldersFromSpaceId(spaceId: spaceId), returnType: WrikeAllFoldersResponseObject.self) { result in
            switch result {
            case .Failure(with: let failureString):
                print("Get folder call failed with cause: \(failureString)")
            case .Success(with: let folderResponse):
                let folders = folderResponse.data
                self.presentFoldersList(from: folders, parentObject: wrikeObject)
            }
        }
    }
    
    private func presentFoldersList(from childFolders: [IdentifiableWrikeObject], parentObject: IdentifiableWrikeObject) {
        var childFolders = childFolders as! [WrikeFolderObject]
        //Removing first item since Wrike returns the parent Space in the folders list
        childFolders.removeFirst()
        let vc = AccountElementsViewController(wrikeObjects: childFolders, parentObject: parentObject, refreshDelegate: self.refreshDelegate)
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    

}
