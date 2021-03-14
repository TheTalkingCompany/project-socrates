//
//  ViewController.swift
//  Socrates
//
//  Created by Harsh Patel on 9/19/19.
//  Copyright © 2019 Harsh Patel. All rights reserved.
//

import UIKit
import Firebase
import TransitionButton
import SafariServices

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var loggEmail: UITextField!
    @IBOutlet weak var loggpass: UITextField!
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor(hex: 0xF2F1EF)
        super.viewDidLoad()
        
        loggEmail.delegate = self
        loggpass.delegate = self

       
        // Do any additional setup after loading the view.
    }


    @IBAction func LoggedIn(_ sender: Any) {
        
        if(loggEmail.text?.last==" "){
            loggEmail.text?.removeLast(1)
        }
            
        
        
        Auth.auth().signIn(withEmail: loggEmail.text!, password: loggpass.text!) { user, error in
            //Check that user isn't nil
                        if let u = user {
                                //User is found, goto home screen
                            self.performSegue(withIdentifier: "Feed", sender: self)
                            
                        }
                        else{
                            
                            print("failed")
                        }
            
            
        }
    }
    //hides keyboard when touched outiside
       override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

              self.view.endEditing(true)
          }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
         let safariVC = SFSafariViewController(url: URL)
         present(safariVC, animated: true, completion: nil)
         return false
     }
    
     func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      if textField == loggEmail {
         textField.resignFirstResponder()
         loggpass.becomeFirstResponder()
      } else if textField == loggpass {
         textField.resignFirstResponder()
      }
     return true
    }
    
}


