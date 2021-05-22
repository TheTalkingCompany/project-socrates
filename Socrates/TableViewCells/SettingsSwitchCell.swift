//
//  SettingsSwitchCell.swift
//  Socrates
//
//  Created by David Jabech on 5/17/21.
//  Copyright © 2021 Harsh Patel. All rights reserved.
//

import UIKit

class SettingsSwitchCell: UITableViewCell {

    static let identifier = "settingsSwitchCell"
    
    private let title: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let iconContainer: UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 7
        return view
    }()
    
    private let iconImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .center
        imageView.tintColor = .white
        return imageView
    }()
    
    private let mySwitch: UISwitch = {
        let mySwitch = UISwitch()
        mySwitch.isOn = false
        return mySwitch
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(title)
        contentView.addSubview(mySwitch)
        contentView.addSubview(iconContainer)
        iconContainer.addSubview(iconImage)
        
        contentView.clipsToBounds = true
        accessoryType = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let size: CGFloat = contentView.frame.size.height - 12
        iconContainer.frame = CGRect(x: 15, y: 10, width: size-5, height: size-5)
        iconImage.frame = CGRect(x: 0.75, y: 0.25, width: iconContainer.frame.size.width-2, height: iconContainer.frame.size.height-2)
        title.frame = CGRect(x: 25+iconContainer.frame.size.width,
                             y: 0,
                             width: contentView.frame.size.width-15-iconContainer.frame.size.width,
                             height: contentView.frame.size.height)
        mySwitch.sizeToFit()
        mySwitch.frame = CGRect(x: (contentView.frame.size.width-mySwitch.frame.size.width)-15,
                                y: (contentView.frame.size.height-mySwitch.frame.size.height)/2,
                                width: mySwitch.frame.size.width,
                                height: mySwitch.frame.size.height)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    public func configure(with model: SwitchSettingsOption) {
        title.text = model.title
        iconImage.image = model.image
        mySwitch.isOn = model.isOn!
        iconContainer.backgroundColor = model.backgroundColor
    }
}
