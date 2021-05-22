//
//  SettingsDefaultCell.swift
//  Socrates
//
//  Created by David Jabech on 5/17/21.
//  Copyright © 2021 Harsh Patel. All rights reserved.
//

import UIKit

class SettingsDefaultCell: UITableViewCell {

    static let identifier = "settingsDefaultCell"
    
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(title)
        contentView.addSubview(iconContainer)
        iconContainer.addSubview(iconImage)
        contentView.clipsToBounds = true
        accessoryType = .disclosureIndicator
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
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        title.text = ""
        iconImage.image = nil
        iconContainer.backgroundColor = .white
    }
    
    public func configure(with model: DefaultSettingsOption) {
        title.text = model.title
        iconImage.image = model.image
        iconContainer.backgroundColor = model.backgroundColor
    }
    
}
