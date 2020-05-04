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
    
    let spaceObjects: [SpaceObject]
    
    init(spaceObjects: [SpaceObject]) {
        self.spaceObjects = spaceObjects
        
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
}

extension SpacesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Add 1 for Shared With Me cell
        return spaceObjects.count + 1
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
        
        if indexPath.row < spaceObjects.count {
            let currentSpaceObject = spaceObjects[indexPath.row]
            
            elementCell.elementTitleButton.setTitle(currentSpaceObject.title, for: .normal)
            do {
                //TODO: Make this prettier
                let imageView = try UIImageView(image: UIImage(data: Data(contentsOf: URL(string: currentSpaceObject.avatarUrl)!))!)
                elementCell.clipboardImage = imageView
                elementCell.clipboardImage.isHidden = false
            } catch {
                elementCell.clipboardImage.isHidden = true
            }
            
            return elementCell
        } else {
            elementCell.elementTitleButton.setTitle("Shared With Me", for: .normal)
            
            return elementCell
        }
    }
    
    
}
