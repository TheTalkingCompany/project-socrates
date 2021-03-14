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
    
    @IBOutlet weak var c: UILabel!
    
    @IBOutlet weak var commentCount: UILabel!
    
    @IBOutlet weak var topic: UILabel!
    @IBOutlet weak var watchCount: UILabel!
    @IBOutlet weak var eye: UILabel!
    
    @IBOutlet weak var agrees: UILabel!
    @IBOutlet weak var agreeCount: UILabel!
    
    @IBOutlet weak var disagrees: UILabel!
    
    @IBOutlet weak var disagreeCount: UILabel!
    
    func setT(topics: Topics) {
        
        c.text = "C:"
        eye.text = "Eye:"
        disagrees.text = "N:"
        agrees.text = "Y:"
        commentCount.text = String(topics.comCount)
        watchCount.text = String(topics.watchCount)
        disagreeCount.text = String(topics.disagrees)
        agreeCount.text = String(topics.agrees)
        topic.text = topics.message
    }
//
}
