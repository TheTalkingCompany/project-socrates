//
//  UploadTopic.swift
//  Socrates
//
//  Created by Harsh Patel on 11/4/19.
//  Copyright © 2019 Harsh Patel. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore


class UploadTopic: UIViewController {
    
    
    let user = Auth.auth().currentUser
    
    
    @IBOutlet weak var topicText: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
    }
    
    
    @IBAction func postTopic(_ sender: Any) {
        
        let db = Firestore.firestore()
        var ref: DocumentReference? = nil
        ref = db.collection("topics").addDocument(data: [
            "topic": topicText.text as Any,
            "comCount": 0 as Int,
            "watchCount": 1 as Int,
            "id": user?.uid as Any,
            "agrees": 0 as Int,
            "disagrees": 0 as Int
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
                self.performSegue(withIdentifier: "Back2Feed", sender: self)
                
            }
        }
        
        
        
    }
    
    
    
}
