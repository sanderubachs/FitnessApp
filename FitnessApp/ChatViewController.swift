//
//  ChatViewController.swift
//  FitnessApp
//
//  Created by issd on 07/01/2019.
//  Copyright © 2019 Fontys. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
import FirebaseCore

struct Post2 {
    let bodyText: String!
    let username: String!
}

var name : String?
var get_uid : String!

var naamVar = String()
var onderwerpVar = String()
var beschrijvingVar = String()
var taalVar = String()
var datumVar = String()

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var messageText: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var naamLabel: UILabel!
    @IBOutlet weak var onderwerpLabel: UILabel!
    @IBOutlet weak var beschrijvingLabel: UILabel!
    @IBOutlet weak var taalLabel: UILabel!
    @IBOutlet weak var datumLabel: UILabel!
    
    var ref: DatabaseReference!
    var ref2: DatabaseReference!
    
    var posts = [Post2]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = name
        
        tableView.reloadData()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let uid = Auth.auth().currentUser?.uid
        
        let database = Database.database().reference()
//        database.child("Messages").child(currentUserChatId).queryOrderedByKey().observe(.childAdded, with: {
//        database.child("Messages").child(currentUserChatId).queryOrderedByKey().queryEqual(toValue: my_uid)
//        query.observe(.value, with: {
//            (snapshot) in
        
        
//        self.ref = Database.database().reference().child("Messages")
//        let query = self.ref.queryOrdered(byChild: "user-uid").queryEqual(toValue: get_uid!)
//        query.observe(.value, with: { (snapshot) in
//            print("my_uid: \(get_uid!)")
//            print("uid: \(uid!)")
        
//        if (get_uid == uid){
            database.child("Messages").child(currentUserChatId).queryOrderedByKey().observe(.childAdded, with: {
                snapshot in
                
                let bodyText = (snapshot.value as? NSDictionary)?["bodyText"] as? String ?? ""
                let userName = (snapshot.value as? NSDictionary)?["username"] as? String ?? ""
                
                self.posts.insert(Post2(bodyText: bodyText, username: userName), at: 0)
                self.tableView.reloadData()
            })
            
            tableView.reloadData()
            
            naamLabel.text = naamVar
            onderwerpLabel.text = onderwerpVar
            beschrijvingLabel.text = beschrijvingVar
            taalLabel.text = taalVar
            datumLabel.text = datumVar
            
            //        print("naamV: \(naamVar)")
            //        print("onderV: \(onderwerpVar)")
            //        print("taalV: \(taalVar)")

        }
    }
    
    func commonInit(_ title: String, user_uid: String) {
        //        navigationItem.title = "harry"
        //        self.title = title
        
        name = title
        get_uid = user_uid
        
        print("title: \(title)")
    }
    
    func commonInit2(naam: String, onderwerp: String, datum: String, taal: String, beschrijving: String) {
        naamVar = naam
        onderwerpVar = onderwerp
        datumVar = datum
        beschrijvingVar = beschrijving
        taalVar = taal
        
        //        print("TAAL: \(taal)")
        //        print("NAAM: \(naam)")
        //        print("OND: \(onderwerp)")
    }
    
    @IBAction func sendMessage(_ sender: Any) {
        if messageText.text != "" {
            let uid = Auth.auth().currentUser?.uid
            
            self.ref2 = Database.database().reference().child("Users")
            let query = self.ref2.queryOrdered(byChild: "uid").queryEqual(toValue: uid)
            query.observe(.value, with: { (snapshot) in
                for user_child in (snapshot.children) {
                    let user_snap = user_child as! DataSnapshot
                    let dict = user_snap.value as! [String: String?]
                    
                    // DEFINE VARIABLES FOR LABELS
                    let voornaam = dict["userNaam"] as? String
                    let achternaam = dict["userAchternaam"] as? String
                    let username = "\(voornaam!) \(achternaam!)"
                    let useruid = get_uid
                    print(username)
                    
                    let database = Database.database().reference()
                    let bodyData : [String : Any] = ["uid" : uid!,
                                                     "bodyText" : self.messageText.text!,
                                                     "username" : username,
                                                     "user-uid" : useruid]
                    database.child("Messages").child(currentUserChatId).childByAutoId().setValue(bodyData)
                    
                    self.messageText.text = ""
                }
            })
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let bodyText = cell.viewWithTag(1) as! UILabel
        bodyText.text = posts[indexPath.row].bodyText
        [bodyText .sizeToFit()]
        
        
        let nameText = cell.viewWithTag(2) as! UILabel
        nameText.text = posts[indexPath.row].username
        
        return cell
    }
}
