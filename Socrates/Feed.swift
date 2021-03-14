//
//  Feed.swift
//  Socrates
//
//  Created by Harsh Patel on 9/19/19.
//  Copyright © 2019 Harsh Patel. All rights reserved.
//

import UIKit
import Firebase



class Feed: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    let topicID = "";
  
//     private var tb: UITableView?
    var topicData: [Topics]=[]
    var refreshControl = UIRefreshControl()
            override func viewDidLoad(){
            
            super.viewDidLoad()
                refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
                refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
                tableView.addSubview(refreshControl)
            
            // Do any additional setup after loading the view.
             
//            self.tableView.register(TopicCell.self, forCellReuseIdentifier: "TopicCell")
                
            
            createTopics()

        }

    
   @objc func refresh() {
    
    createTopics()
    refreshControl.endRefreshing()
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
       super.viewWillAppear(animated)
       createTopics()
       


    }
    
    @IBAction func addTopic(_ sender: Any) {
        
 
    }
    
    
    
    @IBAction func logOut(_ sender: Any) {
            let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
        self.performSegue(withIdentifier: "loggedOut", sender: self)
            print("successful")
            
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
          
        
    }

        
        
        func createTopics() {
            
            var tempTopics: [Topics]=[]

            let db = Firestore.firestore()
            db.collection("topics").getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        print("\(document.documentID) => \(document.data())")

                        if let message = document.data()["topic"] as? String{
                            
                            if let agrees = document.data()["agrees"] as? Int{
                                
                                if let disagrees = document.data()["disagrees"] as? Int{
                                    
                                    if let id = document.data()["id"] as? String{

                                    if let comCount = document.data()["comCount"] as? Int{

                                        if let watchCount = document.data()["watchCount"] as? Int{
                                            let t =  Topics(message: message, comCount: comCount, watchCount: watchCount, agrees: agrees, disagrees: disagrees, id: id)
                                            tempTopics.append(t)
                                   
                                            }
                                        }
                                        
                                    }
                                    
                                }

                            }
//
                        }
                    }
                    self.topicData=tempTopics
                    self.tableView.reloadData()

                }
            }
           
            
        
            
            
           
        }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let tcell = topicData[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TCELL") as! TopicCell

        
        
        cell.setT(topics: tcell)
        
        print((cell))
        
        return cell
        
      }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        print("5")
        return topicData.count
    }
    
//    func numberOfSections(in tableView: UITableView) -> Int {
////        print("5")
//        return 1
//    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc=storyboard?.instantiateViewController(identifier: "ThreadView") as? ThreadView
        
//            self.performSegue(withIdentifier: "Feed", sender: self)
        
        vc?.selectedTopic = topicData[indexPath.row].message
        vc?.threadID = topicData[indexPath.row].id
        vc?.yesses = topicData[indexPath.row].agrees
        vc?.nos = topicData[indexPath.row].disagrees
        print(topicData[indexPath.row].agrees)
        self.navigationController?.pushViewController(vc!, animated: true)
        

    }

}
