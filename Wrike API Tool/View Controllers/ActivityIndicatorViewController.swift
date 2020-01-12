//
//  ActivityIndicatorViewController.swift
//  Wrike API Tool
//
//  Created by Mark Tapia on 1/12/20.
//  Copyright © 2020 Mark Tapia. All rights reserved.
//

import UIKit

class ActivityIndicatorViewController: UIViewController {
    var spinner = UIActivityIndicatorView(style: .gray)

    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.7)

        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        view.addSubview(spinner)

        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}
