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
    
    @IBOutlet weak var topicVIew: TopicsCardDesign!
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
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        tap.cancelsTouchesInView = false
        topicVIew.addGestureRecognizer(tap)
        topicVIew.backgroundColor = UIColor.white

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
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        topicVIew.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
    }
    
    
}
