//
//  SettingsViewController.swift
//  Socrates
//
//  Created by David Jabech on 5/17/21.
//  Copyright © 2021 Harsh Patel. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    private let settingsTable: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(SettingsDefaultCell.self, forCellReuseIdentifier: SettingsDefaultCell.identifier)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

    }
}
