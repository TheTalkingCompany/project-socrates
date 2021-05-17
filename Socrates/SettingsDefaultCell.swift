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
        return view
    }()
    
    private let iconImage: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
}
