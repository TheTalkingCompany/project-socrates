//
//  CommentCell.swift
//  Socrates
//
//  Created by Harsh Patel on 11/8/19.
//  Copyright © 2019 Harsh Patel. All rights reserved.
//

import Foundation
import UIKit
import WebKit
import SafariServices

class CommentCell: UITableViewCell, UITextViewDelegate {
    
    @IBOutlet weak var username: UILabel!
    
    @IBOutlet weak var userCom: UILabel!
    
    @IBOutlet weak var sourceView: UITextView!
    
    @IBOutlet weak var commFacts: UILabel!
    
    @IBOutlet weak var commOpinions: UILabel!
    
    @IBOutlet weak var Opinions: UILabel!
    @IBOutlet weak var Facts: UILabel!
    
    var updateFact : (() -> Void)? = nil
    var updateOP : (() -> Void)? = nil
    
    
    func setC(comment: Comments) {
        //        sourceView.delegate = self
        //        sourceView.translatesAutoresizingMaskIntoConstraints=true
        //        sourceView.isScrollEnabled = false
        
        
        sourceView.text = comment.source
        username.text = comment.uid
        userCom.text = String(comment.message)
        commFacts.text = String(comment.facts)
        commOpinions.text = String(comment.opinions)
        //        Facts.text = "Facts:"
        //        Opinions.text = "Opinions:"
        
    }
    
    
    @IBAction func factButton(_ sender: Any) {
        
        if let factButton = self.updateFact
        {
            factButton()
            //  user!("pass string")
        }
        
        
    }
    
    
    @IBAction func opinionButton(_ sender: Any) {
        
        
        if let opinionButton = self.updateOP
        {
            
            opinionButton()
        }
    }
}
