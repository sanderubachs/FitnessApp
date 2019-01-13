//
//  ViewController.swift
//  BijlessApp
//
//  Created by issd on 13/12/2018.
//  Copyright © 2018 Fontys. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

var currentUserChatId = String()

struct User {
    let username: String!
    let uid: String!
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var users = [User]()

    @IBOutlet weak var tableView: UITableView!
    
    var ref: DatabaseReference!
    var ref2: DatabaseReference!
    
    var niveauData = [String]()
    var naamData = [String]()
    var achterData = [String]()
    var leeftijdData = [String]()
    var beschrijvingData = [String]()
    var emailData = [String]()
    var uidData = [String]()
    var afstandData = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //aanmaken user voor chat
        let uid = Auth.auth().currentUser?.uid
        let database = Database.database().reference()
        database.child("Users").queryOrderedByKey().observe(.childAdded, with: {
            
            snapshot in
            
            let username = (snapshot.value as? NSDictionary)?["userNaam"] as? String ?? ""
            let uid = (snapshot.value as? NSDictionary)?["uid"] as? String ?? ""
            self.users.append(User(username: username, uid: uid))
            self.tableView.reloadData()
        })
        
        tableView.delegate = self
        tableView.dataSource = self
        
        ref = Database.database().reference().child("Users")
        ref.observe(DataEventType.value, with: { (snapshot) in
            if snapshot.childrenCount>0{
                self.naamData.removeAll()
                self.achterData.removeAll()
                self.niveauData.removeAll()
                self.beschrijvingData.removeAll()
                self.leeftijdData.removeAll()
                self.emailData.removeAll()
                self.uidData.removeAll()
                self.afstandData.removeAll()
                
                for posts in snapshot.children.allObjects as![DataSnapshot]{
                    let postObject = posts.value as? [String: AnyObject]
                    
                    let postNaam = postObject?["userNaam"]
                    let postAchter = postObject?["userAchternaam"]
                    let postNiveau = postObject?["userNiveau"]
                    let postLeeftijd = postObject?["userLeeftijd"]
                    let postBeschrijving = postObject? ["userBeschrijving"]
                    let postAfstand = postObject? ["userAfstand"]
                    let postEmail = postObject?["userEmail"]
                    let postUid = postObject?["uid"]
                    
                    let user = Auth.auth().currentUser
                    if let user = user {
                        let uid = user.uid
                        var email = user.email
                        
                            self.niveauData.append(postNiveau as! String)
                            self.naamData.append(postNaam as! String)
                            self.achterData.append(postAchter as! String)
                            self.leeftijdData.append(postLeeftijd as! String)
                            self.beschrijvingData.append(postBeschrijving as! String)
                            self.afstandData.append(postAfstand as! String)
                            self.emailData.append(postEmail as! String)
                            self.uidData.append(postUid as! String)
                    }
                }
                self.tableView.reloadData()
            }
        })
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return naamData.count
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell
        
        let uid = Auth.auth().currentUser?.uid
        if (uid == uidData[indexPath.row]){
                 cell.lblNaam.text = "Jij (\(naamData[indexPath.row]) \(achterData[indexPath.row]))"
        } else {
                 cell.lblNaam.text = "\(naamData[indexPath.row]) \(achterData[indexPath.row]), \(leeftijdData[indexPath.row])"
        }
        
        cell.lblNiveau.text = "Niveau: \(niveauData[indexPath.row])"
        
        if (Auth.auth().currentUser?.uid == uidData[indexPath.row]){
            cell.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
            cell.lblAfstand.text = ""
        } else {
            cell.lblAfstand.text = afstandData[indexPath.row]
        }
        
        cell.imageProfile.image = UIImage(named: "apple-class-conference-7102.png")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentUserChatId = users[indexPath.row].uid
        
        let vcChat = ChatViewController()
        vcChat.commonInit(users[indexPath.row].username,
                          user_uid: users[indexPath.row].uid)
        vcChat.commonInitData(naam: naamData[indexPath.item],
                           achternaam: achterData[indexPath.item],
                           onderwerp: achterData[indexPath.item],
                           niveau: niveauData[indexPath.item],
                           afstand: afstandData[indexPath.item],
                           beschrijving: beschrijvingData[indexPath.item])
    }
}

