//
//  Feed.swift
//  Socrates
//
//  Created by Harsh Patel on 9/19/19.
//  Copyright © 2019 Harsh Patel. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import HGPlaceholders



class Feed: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    let topicID = "";
    
    //     private var tb: UITableView?
    var topicData: [Topics]=[]
    var filteredData: [Topics]=[]
    var refreshControl = UIRefreshControl()
    override func viewDidLoad(){
        
        super.viewDidLoad()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
        searchBar.delegate = self
        
        
        
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
            UserDefaults.standard.setValue(false, forKey: "LoginKey")
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
                        
                    }
                }
                
                self.topicData=tempTopics
                self.filteredData = self.topicData
                self.tableView.reloadData()
                
            }
        }
        
        
        
        
        
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filteredData = []
        if searchText == "" {
            filteredData = self.topicData
        }
        else {
            for topic in self.topicData {
                if topic.message.lowercased().contains(searchText.lowercased()) {
                    filteredData.append(topic)
                }
            }
        }
        self.tableView.reloadData()
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchBar.showsCancelButton = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        if self.filteredData.count != self.topicData.count {
            self.filteredData = self.topicData
            self.tableView.reloadData()
        }
        searchBar.endEditing(true)
        searchBar.showsCancelButton = false
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let tcell = filteredData[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TCELL") as! TopicCell
        
        //removes gray color when selecting cell
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.white
        cell.selectedBackgroundView = backgroundView
        cell.setT(topics: tcell)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        print("5")
        return filteredData.count
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc=storyboard?.instantiateViewController(identifier: "ThreadView") as? ThreadView
        
        vc?.selectedTopic = filteredData[indexPath.row].message
        vc?.threadID = filteredData[indexPath.row].id
        vc?.yesses = filteredData[indexPath.row].agrees
        vc?.nos = filteredData[indexPath.row].disagrees
        
        self.navigationController?.pushViewController(vc!, animated: true)
        
        
    }
    
    
}
