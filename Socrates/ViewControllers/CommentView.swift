//
//  CommentView.swift
//  Socrates
//
//  Created by Harsh Patel on 11/7/19.
//  Copyright © 2019 Harsh Patel. All rights reserved.
//

import UIKit
import KMPlaceholderTextView
import FirebaseAuth
import FirebaseFirestore

class CommentView: UIViewController {


   
   
    @IBOutlet weak var source: KMPlaceholderTextView!
    
    @IBOutlet weak var message: KMPlaceholderTextView!
    
    
    var instanceOfThreadView: ThreadView!
    var uid = Auth.auth().currentUser?.uid
    var comID = ""
    var username = ""
    let db = Firestore.firestore()
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        print("LOOOOOOOOOOKKKKSTTTTTAGHbgakhsvkhsbvlhf")
//        print("\(comID) This")
//        source.translatesAutoresizingMaskIntoConstraints=true
//        source.sizeToFit()
//        source.isScrollEnabled = false
//        message.translatesAutoresizingMaskIntoConstraints = true
//        message.sizeToFit()
//        message.isScrollEnabled = false
       
        
    

        // Do any additional setup after loading the view.
//        print(uid)
        
       
        db.collection("users").whereField("id", isEqualTo: uid as Any).getDocuments{(querysnapshot,error) in
                           
                           if error != nil{
                               
                               print(error)
                           }
                           else{
                               print("comes in here")
                             for document in querysnapshot!.documents {
                                self.username = document.data()["username"] as! String
                               }
                               
                            print(self.username)

                         
                               
                               
                     }
                 }
        
        
        print("\(username) Gets here")
        
        
    }

    
    @IBAction func submitComment(_ sender: Any) {
        
        var ref: DocumentReference? = nil
                              ref = db.collection("comments").addDocument(data: [
                                  "debateTopic": self.comID as String,
                                 "source": self.source.text as String,
                                 "facts": 0 as Int,
                                 "id": username as String,
                                 "opinions": 0 as Int,
                                 "message": self.message.text as String,
                              ]) { err in
                                  if let err = err {
                                      print("Error adding document: \(err)")
                                  } else {
                                      print("Document added with ID: \(ref!.documentID)")
//                                       self.performSegue(withIdentifier: "back2args", sender: self)
                                    self.db.collection("comments").document(ref!.documentID).setData([ "postID": ref!.documentID ], merge: true)
                                    
                                    self.updateUserCommentCount()
                                    
                                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)

                                    self.dismiss(animated: true, completion: nil)
                                  }
                              }
    }
    
    @IBAction func cancel(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    

    func updateUserCommentCount(){
        
        let usersRef = db.collection("users")
        
        let query = usersRef.whereField("id", isEqualTo: self.uid!)
        
        query.getDocuments(){
            
            (querySnapshot, err) in
            
            if let err = err {
                print("Error getting documents: \(err)")
            }
            else {
                for document in querySnapshot!.documents {
                    
                    let userDoc = document.documentID
                    
                    let incUserCommentField = self.db.collection("users").document(userDoc)
                                                           
                    incUserCommentField.updateData([
                    "comments": FieldValue.increment(Int64(1))]
                    )
                    
    
                    
                    
                }
            }
        }

        
        
    }
    
    
}
