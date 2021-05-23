//
//  ThreadView.swift
//  Socrates
//
//  Created by Harsh Patel on 11/5/19.
//  Copyright © 2019 Harsh Patel. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import WebKit
import SafariServices
import HGPlaceholders

class ThreadView: UIViewController, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource, PlaceholderDelegate {
    
    @IBOutlet weak var clickedTopic: UILabel!
    
    @IBOutlet weak var commentTable: TableView!
    
    //    @IBOutlet weak var sourceView: UITextView!
    
    @IBOutlet weak var noCount: UILabel!
    
    @IBOutlet weak var yesCount: UILabel!
    
    
    //    let argueIcon = UIImage(named: "argue")
    var exists = false
    var exists2 = false
    var opExists = false
    var factExists = false;
    var selectedTopic = ""
    var threadID = ""
    var topicComment : [Comments] = []
    var yesses = 0
    var nos = 0
    var change: DocumentReference? = nil
    
    //    let sourceLabel = CommentCell
    //        var copySourceView:UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        let imageView = UIImageView(image: argueIcon)
        //
        //        imageView.frame = CGRect(x: 100, y: 50, width: 50, height: 50)
        //        view.addSubview(imageView)
        
        //        tableView.allowsSelection = false
        commentTable.allowsSelection = true
        clickedTopic.text = "\(selectedTopic)"
        yesCount.text = "\(yesses)"
        noCount.text = "\(nos)"
        commentTable.showDefault()
        commentTable.showDefault()
        
        getComments()
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "load"), object: nil)
        
        //        print(selectedTopic)
        // Do any additional setup after loading the view.
        //        commentTable.reloadData()
        
        
        
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        let safariVC = SFSafariViewController(url: URL)
        present(safariVC, animated: true, completion: nil)
        return false
    }
    
    @objc func loadList(notification: NSNotification){
        //load data here
        commentTable.showDefault()
        getComments()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cCell = topicComment[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "postedComment") as! CommentCell
        cell.setC(comment: cCell)
        
        cell.updateFact = {
            
            
            let post = self.topicComment[indexPath.row].postID
            
            
            let db = Firestore.firestore()
            
            db.collection("comments").whereField("debateTopic", isEqualTo: self.selectedTopic).whereField("postID", isEqualTo: post).getDocuments{(querysnapshot,error) in
                
                if error != nil{
                    self.commentTable.showErrorPlaceholder()
                    print(error as Any)
                }
                
                else{
                    
                    //see if person already liked it
                    let findPersonForResponse = db.collection("commentStats")
                    
                    let userWhoLeftAResponse = findPersonForResponse.whereField("postID", isEqualTo: post).whereField("user", isEqualTo: Auth.auth().currentUser!.uid)
                    
                    userWhoLeftAResponse.getDocuments{ (snapshot, error) in
                        
                        
                        if error != nil{
                            
                            print(error as Any)
                        }
                        
                        else{
                            
                            for document in snapshot!.documents {
                                
                                self.factExists = true
                                let yes  = document.data()["fact"] as! Bool
                                let opCheck  = document.data()["opinion"] as! Bool
                                
                                if yes {
                                    
                                    db.collection("commentStats").document(document.documentID).setData([ "fact": false ], merge: true)
                                    
                                    
                                    for document in querysnapshot!.documents {
                                        
                                        //                document.upda
                                        
                                        
                                        let decThis = document.documentID
                                        let topicYes = db.collection("comments").document(decThis)
                                        
                                        topicYes.updateData([
                                            "facts": FieldValue.increment(Int64(-1))
                                        ])
                                        
                                        let newAgreeCount = (Int(cell.commFacts.text!) ?? 0) - 1
                                        cell.commFacts.text = "\(newAgreeCount)"
                                        self.masterUpdateCredibility(postId: post, factOrOpinion: "facts", decOrInc: -1)
                                        return
                                    }
                                    
                                    
                                }
                                
                                else{
                                    
                                    db.collection("commentStats").document(document.documentID).setData([ "fact": true ], merge: true)
                                    
                                    if(opCheck){
                                        db.collection("commentStats").document(document.documentID).setData([ "opinion": false ], merge: true)
                                    }
                                    
                                    
                                    for document in querysnapshot!.documents {
                                        
                                        //                document.upda
                                        
                                        if(opCheck){
                                            let decThis = document.documentID
                                            let topicYes = db.collection("comments").document(decThis)
                                            
                                            topicYes.updateData([
                                                "opinions": FieldValue.increment(Int64(-1))
                                            ])
                                            
                                            let newAgreeCount = (Int(cell.commOpinions.text!) ?? 0) - 1
                                            cell.commOpinions.text = "\(newAgreeCount)"
                                            self.masterUpdateCredibility(postId: post, factOrOpinion: "opinions", decOrInc: -1)
                                            
                                        }
                                        
                                        
                                        let incThis = document.documentID
                                        let topicYes = db.collection("comments").document(incThis)
                                        
                                        topicYes.updateData([
                                            "facts": FieldValue.increment(Int64(1))
                                        ])
                                        
                                        let newAgreeCount = (Int(cell.commFacts.text!) ?? 0) + 1
                                        
                                        cell.commFacts.text = "\(newAgreeCount)"
                                        self.masterUpdateCredibility(postId: post, factOrOpinion: "facts", decOrInc: 1)
                                        
                                    }
                                    
                                    
                                    
                                    
                                    
                                }
                                
                                
                            }
                            
                            if(!self.factExists){
                                
                                self.factExists = true
                                let db = Firestore.firestore()
                                var ref: DocumentReference? = nil
                                ref = db.collection("commentStats").addDocument(data: [
                                    "opinion": false as Bool,
                                    "postID": post as String,
                                    "user": Auth.auth().currentUser!.uid as String,
                                    "fact": true as Bool
                                    
                                ]) { err in
                                    if let err = err {
                                        print("Error adding document: \(err)")
                                    } else {
                                        print("Document added with ID: \(ref!.documentID)")
                                        for document in querysnapshot!.documents {
                                            
                                            //                document.upda
                                            
                                            
                                            
                                            let incThis = document.documentID
                                            let topicYes = db.collection("comments").document(incThis)
                                            
                                            topicYes.updateData([
                                                "facts": FieldValue.increment(Int64(1))
                                            ])
                                            
                                            let newAgreeCount = (Int(cell.commFacts.text!) ?? 0) + 1
                                            cell.commFacts.text = "\(newAgreeCount)"
                                            self.masterUpdateCredibility(postId: post, factOrOpinion: "facts", decOrInc: 1)
                                            
                                        }
                                        
                                        
                                    }
                                }
                                
                                
                                
                            }
                            
                        }
                        
                    }
                    
                    
                    
                }
                
            }
            
            
        }
        cell.updateOP={
            let post = self.topicComment[indexPath.row].postID
            
            
            let db = Firestore.firestore()
            
            db.collection("comments").whereField("debateTopic", isEqualTo: self.selectedTopic).whereField("postID", isEqualTo: post).getDocuments{(querysnapshot,error) in
                
                if error != nil{
                    
                    print(error as Any)
                }
                
                else{
                    
                    //see if person already liked it
                    let findPersonForResponse = db.collection("commentStats")
                    
                    let userWhoLeftAResponse = findPersonForResponse.whereField("postID", isEqualTo: post).whereField("user", isEqualTo: Auth.auth().currentUser!.uid)
                    
                    userWhoLeftAResponse.getDocuments{ (snapshot, error) in
                        
                        
                        if error != nil{
                            
                            print("enters here")
                        }
                        
                        else{
                            
                            for document in snapshot!.documents {
                                
                                self.opExists = true
                                let yes  = document.data()["opinion"] as! Bool
                                let factCheck  = document.data()["fact"] as! Bool
                                
                                if yes {
                                    
                                    db.collection("commentStats").document(document.documentID).setData([ "opinion": false ], merge: true)
                                    
                                    
                                    for document in querysnapshot!.documents {
                                        
                                        //                document.upda
                                        
                                        
                                        let decThis = document.documentID
                                        let topicYes = db.collection("comments").document(decThis)
                                        
                                        topicYes.updateData([
                                            "opinions": FieldValue.increment(Int64(-1))
                                        ])
                                        
                                        let newAgreeCount = (Int(cell.commOpinions.text!) ?? 0) - 1
                                        cell.commOpinions.text = "\(newAgreeCount)"
                                        self.masterUpdateCredibility(postId: post, factOrOpinion: "opinions", decOrInc: -1)
                                        return
                                    }
                                    
                                    
                                }
                                
                                else if yes==false{
                                    
                                    db.collection("commentStats").document(document.documentID).setData([ "opinion": true ], merge: true)
                                    
                                    if(factCheck){
                                        db.collection("commentStats").document(document.documentID).setData([ "opinion": false ], merge: true)
                                    }
                                    
                                    for document in querysnapshot!.documents {
                                        
                                        //                document.upda
                                        
                                        if(factCheck){
                                            let decThis = document.documentID
                                            let topicYes = db.collection("comments").document(decThis)
                                            
                                            topicYes.updateData([
                                                "facts": FieldValue.increment(Int64(-1))
                                            ])
                                            
                                            let newAgreeCount = (Int(cell.commOpinions.text!) ?? 0) - 1
                                            cell.commOpinions.text = "\(newAgreeCount)"
                                            self.masterUpdateCredibility(postId: post, factOrOpinion: "opinions", decOrInc: -1)
                                            
                                        }
                                        
                                        
                                        
                                        let incThis = document.documentID
                                        let topicYes = db.collection("comments").document(incThis)
                                        
                                        topicYes.updateData([
                                            "opinions": FieldValue.increment(Int64(1))
                                        ])
                                        
                                        let newAgreeCount = (Int(cell.commOpinions.text!) ?? 0) + 1
                                        cell.commOpinions.text = "\(newAgreeCount)"
                                        self.masterUpdateCredibility(postId: post, factOrOpinion: "opinions", decOrInc: 1)
                                        
                                    }
                                    
                                    
                                    
                                    
                                    
                                }
                                
                                
                                
                                
                                
                            }
                            
                            
                            if(!self.opExists){
                                self.opExists = true
                                let db = Firestore.firestore()
                                var ref: DocumentReference? = nil
                                ref = db.collection("commentStats").addDocument(data: [
                                    "opinion": true as Bool,
                                    "postID": post as String,
                                    "user": Auth.auth().currentUser!.uid as String,
                                    "fact": false as Bool
                                    
                                ]) { err in
                                    if let err = err {
                                        print("Error adding document: \(err)")
                                    } else {
                                        print("Document added with ID: \(ref!.documentID)")
                                        for document in querysnapshot!.documents {
                                            
                                            //                document.upda
                                            let incThis = document.documentID
                                            let topicYes = db.collection("comments").document(incThis)
                                            
                                            topicYes.updateData([
                                                "opinions": FieldValue.increment(Int64(1))
                                            ])
                                            
                                            let newAgreeCount = (Int(cell.commOpinions.text!) ?? 0) + 1
                                            cell.commOpinions.text = "\(newAgreeCount)"
                                            self.masterUpdateCredibility(postId: post, factOrOpinion: "opinions", decOrInc: 1)
                                            
                                        }
                                        
                                        
                                    }
                                }
                                
                                
                                
                            }
                            
                            
                            
                            
                        }
                        
                    }
                    
                }
                
            }
            
        }
        
        print("enered tabvler")
        //        print(cell.userCom.text)
        
        return cell
        
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let url = URL(string: "https://"+topicComment[indexPath.row].source) {
            let safariVC = SFSafariViewController(url: url)
            
            present(safariVC, animated: true, completion: nil)
        }
        
        print("which comes first")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topicComment.count
    }
    
    
    
    
    @IBAction func timeToDebate(_ sender: Any) {
        //        print("Do i have it here though?")
        //        print("\(threadID)")
        
        self.performSegue(withIdentifier: "debate", sender: self)
        
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //           let vc=storyboard?.instantiateViewController(identifier: "ComView") as? CommentView
        
        getComments()
        change?.updateData(["comCount": self.topicComment.count])
        
        let vc = segue.destination as? CommentView
        vc?.comID = selectedTopic
        
        vc?.instanceOfThreadView = self
    }
    
    func getComments(){
        var counter = 0;
        var tempComments: [Comments]=[]
        let db = Firestore.firestore()
        //         print("DEBUGGGGGGGGG!!!!!!")
        //        print(selectedTopic)
        db.collection("comments").whereField("debateTopic", isEqualTo: selectedTopic).getDocuments{(querysnapshot,error) in
            
            if error != nil{
                
                print(error as Any)
            }
            
            else{
                for document in querysnapshot!.documents {
                    //                                        print("\(document.documentID) => \(document.data())")
                    
                    if let message = document.data()["message"] as? String{
                        
                        if let tID = document.data()["debateTopic"] as? String{
                            
                            if let facts = document.data()["facts"] as? Int{
                                
                                if let id = document.data()["id"] as? String{
                                    
                                    if let opinions = document.data()["opinions"] as? Int{
                                        
                                        if let postid = document.data()["postID"] as? String{
                                            
                                            if let source = document.data()["source"] as? String{
                                                let cmmts =  Comments(message: message, uid: id, source: source, topicID: tID, facts: facts, opinions: opinions, postID: postid)
                                                tempComments.append(cmmts)
                                                counter = counter+1
                                                print("DEBUGGGGGGGGG")
                                                
                                            }
                                        }
                                        
                                    }
                                    
                                }
                                
                            }
                            
                        }
                        
                    }
                    
                    
                }
                self.topicComment=tempComments
                self.commentTable.reloadData()
                
                
                db.collection("topics").whereField("topic", isEqualTo: self.selectedTopic).getDocuments{(querysnapshot,error) in
                    
                    if error != nil{
                        
                        print(error as Any)
                    }
                    
                    else{
                        
                        for document in querysnapshot!.documents {
                            
                            //                document.upda
                            //                                      print("infinite here")
                            //                                      self.getComments()
                            
                            let incThis = document.documentID
                            let topicNo = db.collection("topics").document(incThis)
                            self.change = topicNo
                            
                            topicNo.updateData([
                                "comCount": self.topicComment.count
                            ])
                            
                            
                        }
                        
                        
                        
                    }
                    
                }
                
                
                
                
                
            }
            
        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        //        topicData = createTopics()
        //            commentTable.reloadData()
        commentTable.showDefault()
        print("infinite")
        getComments()
        commentTable.estimatedRowHeight = 100
        commentTable.rowHeight = UITableView.automaticDimension
        
        
        
    }
    
    @IBAction func yes(_ sender: Any) {
        //        print(threadID)
        let db = Firestore.firestore()
        
        db.collection("topics").whereField("topic", isEqualTo: selectedTopic).getDocuments{(querysnapshot,error) in
            
            if error != nil{
                print(error as Any)
            }
            
            else{
                
                //see if person already liked it
                let findPersonForResponse = db.collection("topicYes")
                
                let userWhoLeftAResponse = findPersonForResponse.whereField("topic", isEqualTo: self.selectedTopic).whereField("user", isEqualTo: Auth.auth().currentUser!.uid)
                
                
                userWhoLeftAResponse.getDocuments{ (snapshot, error) in
                    
                    
                    if error != nil{
                        
                        print("No such entry exists, and this is how you fix it")
                    }
                    
                    else{
                        
                        for document in snapshot!.documents {
                            
                            self.exists = true
                            let yes  = document.data()["yes"] as! Bool
                            let noCheck  = document.data()["no"] as! Bool
                            
                            if yes {
                                
                                db.collection("topicYes").document(document.documentID).setData([ "yes": false ], merge: true)
                                
                                
                                for document in querysnapshot!.documents {
                                    
                                    //                document.upda
                                    
                                    
                                    let decThis = document.documentID
                                    let topicYes = db.collection("topics").document(decThis)
                                    
                                    topicYes.updateData([
                                        "agrees": FieldValue.increment(Int64(-1))
                                    ])
                                    
                                    let newAgreeCount = (Int(self.yesCount.text!) ?? 0) - 1
                                    self.yesCount.text = "\(newAgreeCount)"
                                    return
                                }
                                
                                
                            }
                            
                            else{
                                
                                db.collection("topicYes").document(document.documentID).setData([ "yes": true ], merge: true)
                                
                                if(noCheck){
                                    db.collection("topicYes").document(document.documentID).setData([ "no": false ], merge: true)
                                    
                                    
                                }
                                
                                for document in querysnapshot!.documents {
                                    
                                    //                document.upda
                                    
                                    if(noCheck){
                                        let decThis = document.documentID
                                        let topicNo = db.collection("topics").document(decThis)
                                        
                                        topicNo.updateData([
                                            "disagrees": FieldValue.increment(Int64(-1))
                                        ])
                                        
                                        let newDisAgreeCount = (Int(self.noCount.text!) ?? 0) - 1
                                        self.noCount.text = "\(newDisAgreeCount)"
                                        
                                    }
                                    
                                    let incThis = document.documentID
                                    let topicYes = db.collection("topics").document(incThis)
                                    
                                    topicYes.updateData([
                                        "agrees": FieldValue.increment(Int64(1))
                                    ])
                                    
                                    let newAgreeCount = (Int(self.yesCount.text!) ?? 0) + 1
                                    self.yesCount.text = "\(newAgreeCount)"
                                    
                                }
                                
                                
                                
                                
                                
                            }
                            
                            
                        }
                        
                        if(!self.exists){
                            
                            print("YES!!!!")
                            self.exists = true
                            
                            let db = Firestore.firestore()
                            var ref: DocumentReference? = nil
                            ref = db.collection("topicYes").addDocument(data: [
                                "no": false as Bool,
                                "topic": self.selectedTopic as String,
                                "user": Auth.auth().currentUser!.uid as String,
                                "yes": true as Bool
                                
                            ]) { err in
                                if let err = err {
                                    print("Error adding document: \(err)")
                                } else {
                                    print("Document added with ID: \(ref!.documentID)")
                                    for document in querysnapshot!.documents {
                                        
                                        //                document.upda
                                        
                                        
                                        let incThis = document.documentID
                                        let topicYes = db.collection("topics").document(incThis)
                                        
                                        topicYes.updateData([
                                            "agrees": FieldValue.increment(Int64(1))
                                        ])
                                        
                                        let newAgreeCount = (Int(self.yesCount.text!) ?? 0) + 1
                                        self.yesCount.text = "\(newAgreeCount)"
                                        
                                    }
                                    
                                    
                                }
                            }
                            
                        }
                        
                        
                        
                    }
                    
                }
                
                
                
            }
            
        }
        
        
        
        
    }
    
    @IBAction func no(_ sender: Any) {
        let db = Firestore.firestore()
        
        db.collection("topics").whereField("topic", isEqualTo: selectedTopic).getDocuments{(querysnapshot,error) in
            
            if error != nil{
                
                print(error as Any)
            }
            
            else{
                //see if person already liked it
                let findPersonForResponse = db.collection("topicYes")
                
                let userWhoLeftAResponse = findPersonForResponse.whereField("topic", isEqualTo: self.selectedTopic).whereField("user", isEqualTo: Auth.auth().currentUser!.uid)
                
                userWhoLeftAResponse.getDocuments{ (snapshot, error) in
                    
                    
                    if error != nil{
                        
                        print(error as Any)
                    }
                    
                    else{
                        
                        for document in snapshot!.documents {
                            
                            self.exists2 = true
                            
                            let no  = document.data()["no"] as! Bool
                            let yesCheck  = document.data()["yes"] as! Bool
                            
                            if no {
                                
                                db.collection("topicYes").document(document.documentID).setData([ "no": false ], merge: true)
                                
                                
                                for document in querysnapshot!.documents {
                                    
                                    //                document.upda
                                    
                                    
                                    let decThis = document.documentID
                                    let topicNo = db.collection("topics").document(decThis)
                                    
                                    topicNo.updateData([
                                        "disagrees": FieldValue.increment(Int64(-1))
                                    ])
                                    
                                    let newDisAgreeCount = (Int(self.noCount.text!) ?? 0) - 1
                                    self.noCount.text = "\(newDisAgreeCount)"
                                    return
                                }
                                
                                
                            }
                            
                            else{
                                
                                db.collection("topicYes").document(document.documentID).setData([ "no": true ], merge: true)
                                
                                if(yesCheck){
                                    db.collection("topicYes").document(document.documentID).setData([ "yes": false ], merge: true)
                                    
                                }
                                
                                for document in querysnapshot!.documents {
                                    
                                    //                document.upda
                                    if(yesCheck){
                                        
                                        
                                        
                                        let decThis = document.documentID
                                        let topicYes = db.collection("topics").document(decThis)
                                        
                                        topicYes.updateData([
                                            "agrees": FieldValue.increment(Int64(-1))
                                        ])
                                        
                                        let newAgreeCount = (Int(self.yesCount.text!) ?? 0) - 1
                                        self.yesCount.text = "\(newAgreeCount)"
                                        
                                    }
                                    
                                    
                                    
                                    let incThis = document.documentID
                                    let topicNo = db.collection("topics").document(incThis)
                                    
                                    topicNo.updateData([
                                        "disagrees": FieldValue.increment(Int64(1))
                                    ])
                                    
                                    let newDisAgreeCount = (Int(self.noCount.text!) ?? 0) + 1
                                    self.noCount.text = "\(newDisAgreeCount)"
                                    
                                }
                                
                                
                            }
                            
                            
                        }
                        
                        
                        if(!self.exists2){
                            
                            print("NOOO!!!!")
                            self.exists2 = true
                            
                            let db = Firestore.firestore()
                            var ref: DocumentReference? = nil
                            ref = db.collection("topicYes").addDocument(data: [
                                "no": true as Bool,
                                "topic": self.selectedTopic as String,
                                "user": Auth.auth().currentUser!.uid as String,
                                "yes": false as Bool
                                
                            ]) { err in
                                if let err = err {
                                    print("Error adding document: \(err)")
                                } else {
                                    print("Document added with ID: \(ref!.documentID)")
                                    
                                    for document in querysnapshot!.documents {
                                        
                                        //                document.upda
                                        
                                        
                                        let incThis = document.documentID
                                        let topicNo = db.collection("topics").document(incThis)
                                        
                                        topicNo.updateData(["disagrees": FieldValue.increment(Int64(1))])
                                        
                                        let newDisAgreeCount = (Int(self.noCount.text!) ?? 0) + 1
                                        self.noCount.text = "\(newDisAgreeCount)"
                                        
                                    }
                                    
                                }
                            }
                            
                        }
                        
                        
                    }
                    
                }
                
                
                
            }
            
        }
        
        
        
        
    }
    
    
    
    
    func updateUserCredibility(factOrOpinion: String, id: String, decOrInc: Int){
        let db = Firestore.firestore()
        let usersRef = db.collection("users")
        
        let query = usersRef.whereField("username", isEqualTo: id)
        
        query.getDocuments(){
            
            (querySnapshot, err) in
            
            if let err = err {
                print("Error getting documents: \(err)")
            }
            else {
                for document in querySnapshot!.documents {
                    
                    let userDoc = document.documentID
                    
                    let incField = db.collection("users").document(userDoc)
                    
                    if decOrInc == 1{
                        
                        incField.updateData([
                                                factOrOpinion: FieldValue.increment(Int64(1))]
                        )
                        
                    }
                    
                    else {
                        
                        incField.updateData([
                                                factOrOpinion: FieldValue.increment(Int64(-1))]
                        )
                    }
                    
                }
            }
        }
        
    }
    
    func masterUpdateCredibility(postId: String, factOrOpinion: String, decOrInc: Int){
        let db = Firestore.firestore()
        
        let ref = db.collection("comments")
        
        let query = ref.whereField("postID", isEqualTo: postId)
        query.getDocuments(){
            
            (querySnapshot, err) in
            
            if let err = err {
                print("Error getting documents: \(err)")
            }
            else {
                for document in querySnapshot!.documents {
                    
                    if let id = document.data()["id"] as? String{
                        
                        self.updateUserCredibility(factOrOpinion: factOrOpinion, id: id, decOrInc: decOrInc)
                        
                    }
                    
                    else {
                        print("No username found for that post")
                    }
                }
            }
        }
        
        
        
    }
    
    func view(_ view: Any, actionButtonTappedFor placeholder: Placeholder) {
        print(placeholder.key.value)
    }
    
    
    
    
    
    
    @IBAction func factButton(_ sender: Any) {
        
        
        
        
        
        
        
    }
    
    @IBAction func opButton(_ sender: Any) {
        
        
    }
    
}

