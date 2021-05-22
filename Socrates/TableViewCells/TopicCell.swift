//
//  TopicCell.swift
//  Socrates
//
//  Created by Harsh Patel on 11/3/19.
//  Copyright © 2019 Harsh Patel. All rights reserved.
//

import Foundation
import UIKit

class TopicCell: UITableViewCell {
    
    @IBOutlet weak var commentCount: UILabel!
    @IBOutlet weak var topic: UILabel!
    @IBOutlet weak var watchCount: UILabel!
    @IBOutlet weak var agreeCount: UILabel!
    @IBOutlet weak var eyeIcon: UIImageView!
    @IBOutlet weak var disagreeCount: UILabel!
    @IBOutlet weak var agreeIcon: UIImageView!
    @IBOutlet weak var disagreeIcon: UIImageView!
    @IBOutlet weak var commentIcon: UIImageView!
    
    func setT(topics: Topics) {
        eyeIcon.image = UIImage(systemName: "eye.fill")
        agreeIcon.image = UIImage(systemName: "hand.thumbsup.fill")
        disagreeIcon.image = UIImage(systemName: "hand.thumbsdown.fill")
        commentIcon.image = UIImage(systemName: "text.bubble.fill")
        commentCount.text = String(topics.comCount)
        watchCount.text = String(topics.watchCount)
        disagreeCount.text = String(topics.disagrees)
        agreeCount.text = String(topics.agrees)
        topic.text = topics.message
        
    }
//
}
