//
//  ProfileView.swift
//  Socrates
//
//  Created by Harsh Patel on 12/2/19.
//  Copyright © 2019 Harsh Patel. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ProfileView: UIViewController {
    
    @IBOutlet weak var usernmae: UILabel!
    
    @IBOutlet weak var comms: UILabel!
    
    
    @IBOutlet weak var facts: UILabel!
    
    @IBOutlet weak var opinions: UILabel!
    @IBOutlet weak var debScore: UILabel!
    
    let uid = Auth.auth().currentUser?.uid
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserStats()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        getUserStats()
    }
    
    
    
    func getUserStats(){
        
        let db = Firestore.firestore()
        
        db.collection("users").whereField("id", isEqualTo: uid as Any).getDocuments{(querysnapshot,error) in
            
            if error != nil{
                
                print(error as Any)
            }
            
            else{
                for document in querysnapshot!.documents {
                    
                    self.usernmae.text = document.data()["username"] as? String
                    
                    let debateScore = document.data()["debateScore"] as? Int
                    
                    self.debScore.text = "Debate Score: \(debateScore ?? 0)"
                    
                    
                    let commwrites = document.data()["comments"] as? Int
                    
                    self.comms.text = "Comments: \(commwrites ?? 0)"
                    
                    let fcts = document.data()["facts"] as? Int
                    
                    self.facts.text = "Facts: \(fcts ?? 0)"
                    
                    let opins = document.data()["opinions"] as? Int
                    
                    self.opinions.text = "Opinions: \(opins ?? 0)"
                    
                    
                    
                }
                
                
                
            }
            
        }
        
        
    }
    
    
    
    
    
}
