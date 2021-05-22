//
//  Registration.swift
//  Socrates
//
//  Created by Harsh Patel on 9/19/19.
//  Copyright © 2019 Harsh Patel. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import TransitionButton

class Registration: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passText: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var errorLabel2: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var errorLabel3: UILabel!
    
    var test = 0
    
    override func viewDidLoad() {
    
        view.backgroundColor = UIColor(hex: 0xF2F1EF)
        super.viewDidLoad()
        
        
        emailText.delegate = self
        passText.delegate = self
        



        
        
    }
    @IBAction func backButton(_ sender: Any) {
        
        
    }
    
    //hides keyboard when touched outiside
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

           self.view.endEditing(true)
       }
    
    //hides keyboard when pressed enter
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

       if textField == userName {
                 textField.resignFirstResponder()
                 emailText.becomeFirstResponder()
              }
       else if textField == emailText {
                 textField.resignFirstResponder()
                 passText.becomeFirstResponder()
              }
       else if textField == passText {
                 textField.resignFirstResponder()
              }

        return true;
    }

    @IBAction func Register(_ button: TransitionButton) {
        
        errorLabel.text = ""
         errorLabel2.text = ""
        errorLabel3.text = ""
      
        button.startAnimation()
        
        Auth.auth().createUser(withEmail:  emailText.text!, password: passText.text!) { authResult, error in
           
              //Check that user isn't NIL
                         if let u = authResult {
                            
                                    button.stopAnimation(animationStyle: .expand, completion: {
//                                  let secondVC = ViewController()
//                                  self.present(secondVC, animated: true, completion: nil)
                                 
                                        let db = Firestore.firestore()
                                               var ref: DocumentReference? = nil
                                               ref = db.collection("users").addDocument(data: [
                                                  "comments": 0 as Int,
                                                  "opinions": 0 as Int,
                                                  "facts": 0 as Int,
                                                  "username": self.userName.text as Any,
                                                  "debateScore": 1 as Int,
                                                  "id": u.user.uid as Any
                                               ]) { err in
                                                   if let err = err {
                                                       print("Error adding document: \(err)")
                                                   } else {
                                                       print("Document added with ID: \(ref!.documentID)")
//                                                        self.performSegue(withIdentifier: "Back2Feed", sender: self)
                                                   }
                                               }
                                        
                                    self.performSegue(withIdentifier: "returnHome", sender: self)
                                                                             
                                    })
                            
                         }
                         else {
                             print("failed")
                            button.stopAnimation(animationStyle: .shake, completion: {
                                                                    
                                
                                if self.emailText.text=="" {
                                    self.errorLabel.text = "You forgot to put an email"
                                     }
                                
                                if self.userName.text=="" {
                                self.errorLabel3.text = "You forgot to put a username"
                                 }
                                     
                                if self.passText.text=="" {
                                    self.errorLabel2.text = "You forgot to put a password"
                                        }
                                
                                else {self.errorLabel.text = "This email has been taken"}
                                
                                                                                                
                            })
                            
                         }
    
            
        }
        
        
        
        

        
        
        
        
        
        
    }
}
