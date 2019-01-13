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

struct Post {
    let bodyText: String!
    let username: String!
}

var name : String?
var get_uid : String!

var naamVar = String()
var onderwerpVar = String()
var beschrijvingVar = String()
var afstandVar = String()
var niveauVar = String()

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var messageText: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var naamLabel: UILabel!
    @IBOutlet weak var beschrijvingLabel: UILabel!
    @IBOutlet weak var niveauLabel: UILabel!
    @IBOutlet weak var afstandLabel: UILabel!
    
    var ref: DatabaseReference!
    var ref2: DatabaseReference!
    
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = name
        
        tableView.reloadData()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let database = Database.database().reference()
        
            database.child("Messages").child(currentUserChatId).queryOrderedByKey().observe(.childAdded, with: {
                snapshot in
                
                let bodyText = (snapshot.value as? NSDictionary)?["bodyText"] as? String ?? ""
                let userName = (snapshot.value as? NSDictionary)?["username"] as? String ?? ""
                
                self.posts.insert(Post(bodyText: bodyText, username: userName), at: 0)
                self.tableView.reloadData()
            })
            
            tableView.reloadData()
            
            naamLabel.text = naamVar
            beschrijvingLabel.text = beschrijvingVar
            afstandLabel.text = afstandVar
            niveauLabel.text = niveauVar
        
        [beschrijvingLabel .sizeToFit()]
        
        self.hideKeyboardWhenTappedAround()
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ChatViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func commonInit(_ title: String, user_uid: String) {        
        name = title
        get_uid = user_uid
    }
    
    func commonInitData(naam: String, achternaam: String, onderwerp: String, niveau: String, afstand: String, beschrijving: String) {
        naamVar = "\(naam) \(achternaam)"
        onderwerpVar = onderwerp
        niveauVar = niveau
        afstandVar = afstand
        beschrijvingVar = beschrijving
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
                    
                    let database = Database.database().reference()
                    let bodyData : [String : Any] = ["uid" : uid!,
                                                     "bodyText" : self.messageText.text!,
                                                     "username" : username]
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
        return 100
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
