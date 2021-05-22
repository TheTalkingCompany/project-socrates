//
//  Comments.swift
//  Socrates
//
//  Created by Harsh Patel on 11/8/19.
//  Copyright © 2019 Harsh Patel. All rights reserved.
//

import Foundation
import UIKit

class Comments{
    
    var uid: String   //user who posted comment. used to pull usernmae
    var message: String //what the comment is
    var source : String  //their source
    var topicID: String  //debate post
    var facts: Int      //number of facts the comment has
    var opinions: Int   //number of opinions the comment has
    var postID: String
 
    
    
    init(message: String, uid: String, source: String, topicID: String, facts: Int, opinions: Int, postID: String) {
        self.message = message
        self.uid = uid
        self.source = source
        self.topicID = topicID
        self.facts = facts
        self.opinions = opinions
        self.postID = postID
    }
    
    
}
