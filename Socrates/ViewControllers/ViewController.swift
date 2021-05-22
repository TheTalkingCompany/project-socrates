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

       
        //clear placeholder text on touch
        loggEmail.addTarget(self, action: #selector(clearEmailPHT), for: .touchDown)
        loggpass.addTarget(self, action: #selector(clearPasswordPHT), for: .touchDown)


        // Do any additional setup after loading the view.
    }
    
    //clear placeholder text
    @objc func clearEmailPHT(textField: UITextField) {
        self.loggEmail.placeholder = ""
    }
    
    @objc func clearPasswordPHT(textField: UITextField) {
        self.loggpass.placeholder = ""
    }

    @IBAction func LoggedIn(_ button: TransitionButton) {
        
        if(loggEmail.text?.last==" "){
            loggEmail.text?.removeLast(1)
        }
        
        
        button.startAnimation()
        Auth.auth().signIn(withEmail: loggEmail.text!, password: loggpass.text!) { user, error in
            //Check that user isn't nil
                        if let u = user {
                                //User is found, goto home screen
                            UserDefaults.standard.setValue(true, forKey: "LoginKey")
                            self.showSpinner()
                            self.performSegue(withIdentifier: "Feed", sender: self)
                            
                        }
                        else{
                            button.stopAnimation(animationStyle: .shake, completion: {
                                if self.loggEmail.text=="" {
                                    self.loggEmail.placeholder = "Please enter an email"
                                }
                                
                                if self.loggpass.text=="" {
                                self.loggpass.placeholder = "Please enter a password"
                                 }
                                     
                            
                            })
                            self.removeSpinner()
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


