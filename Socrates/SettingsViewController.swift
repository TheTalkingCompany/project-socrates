//
//  SettingsViewController.swift
//  Socrates
//
//  Created by David Jabech on 5/17/21.
//  Copyright © 2021 Harsh Patel. All rights reserved.
//

import UIKit

struct SettingsSection {
    let title: String?
    let options: [SettingsOptionType]
}

enum SettingsOptionType {
    case defaultCell(model: DefaultSettingsOption)
    case switchCell(model: SwitchSettingsOption)
}

struct DefaultSettingsOption {
    let title: String?
    let image: UIImage?
    let backgroundColor: UIColor?
    let handler: (()->Void)
}

struct SwitchSettingsOption {
    let title: String?
    let image: UIImage?
    let backgroundColor: UIColor?
    let isOn: Bool?
    let handler: (()->Void)
}


class SettingsViewController: UIViewController {
    
    private var settingsSections = [SettingsSection]()
    
    private let settingsTable: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(SettingsDefaultCell.self, forCellReuseIdentifier: SettingsDefaultCell.identifier)
        table.register(SettingsSwitchCell.self, forCellReuseIdentifier: SettingsSwitchCell.identifier)
        table.separatorInset = UIEdgeInsets(top: 0, left: 51, bottom: 0, right: 0)
        return table
    }()
    
    public func configureCells() {
        settingsSections.append(SettingsSection(title: "",
                                                options: [.defaultCell(model: DefaultSettingsOption(title: "Change App Icon",
                                                                                                    image: UIImage(systemName: "building.columns.fill"),
                                                                                                    backgroundColor: UIColor(hex: 0x4aa96c),
                                                                                                    handler: { })),
                                                          .switchCell(model: SwitchSettingsOption(title: "Dark Mode",
                                                                                                  image: UIImage(systemName: "moon.fill"),
                                                                                                  backgroundColor: UIColor(hex: 0x511281),
                                                                                                  isOn: true,
                                                                                                  handler: { }))
                                                ]))
        
        settingsSections.append(SettingsSection(title: "",
                                                options: [.defaultCell(model: DefaultSettingsOption(title: "About",
                                                                                                    image: UIImage(systemName: "at"),
                                                                                                    backgroundColor: UIColor(hex: 0x233e8b),
                                                                                                    handler: { } )),
                                                          .defaultCell(model: DefaultSettingsOption(title: "Tip Jar",
                                                                                                    image: UIImage(systemName: "heart.fill"),
                                                                                                    backgroundColor: UIColor(hex: 0xff7171),
                                                                                                    handler: { }))
                                                ]))
        settingsSections.append(SettingsSection(title: "",
                                                options: [.defaultCell(model: DefaultSettingsOption(title: "Remove Ads",
                                                                                                                image: UIImage(systemName: "nosign"),
                                                                                                                backgroundColor: .systemRed,
                                                                                                                handler: { }))
        ]))
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(settingsTable)
        settingsTable.frame = view.bounds
        settingsTable.delegate = self
        settingsTable.dataSource = self
        configureCells()
    }
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return settingsSections[section].title
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return settingsSections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsSections[section].options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = settingsSections[indexPath.section].options[indexPath.row]
       
        switch model {
        case .defaultCell(model: let model):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingsDefaultCell.identifier, for: indexPath) as? SettingsDefaultCell else {
                return UITableViewCell()
            }
            cell.configure(with: model)
            return cell
        case .switchCell(model: let model):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingsSwitchCell.identifier, for: indexPath) as?
                    SettingsSwitchCell else {
                return UITableViewCell()
            }
            cell.configure(with: model)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}
