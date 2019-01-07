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
    
    var afstandData = [String]()
    
//    var profileData = [String]()
    
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

//                self.afstandData.removeAll()
                
                for posts in snapshot.children.allObjects as![DataSnapshot]{
                    let postObject = posts.value as? [String: AnyObject]
                    
                    let postNaam = postObject?["userNaam"]
                    let postAchter = postObject?["userAchternaam"]
                    let postNiveau = postObject?["userNiveau"]
                    let postLeeftijd = postObject?["userLeeftijd"]
                    let postBeschrijving = postObject? ["userBeschrijving"]
                    let postAfstand = postObject? ["userAfstand"]
                    let postEmail = postObject?["userEmail"]
                    //                    let postProfile = postObject?["postProfile"]
                    
                    //if currentuser = naamData : niet toevoegen
                    let user = Auth.auth().currentUser
                    if let user = user {
                        let uid = user.uid
                        var email = user.email
                        
                        //voorkom dat eigen account wordt weergegeven in lijst
                        if (email == (postEmail as! String)) {
                            print("email-yes: \(self.emailData)")
                        } else {                            
                            self.niveauData.append(postNiveau as! String)
                            self.naamData.append(postNaam as! String)
                            self.achterData.append(postAchter as! String)
                            self.leeftijdData.append(postLeeftijd as! String)
                            self.beschrijvingData.append(postBeschrijving as! String)
                            self.afstandData.append(postAfstand as! String)
                            self.emailData.append(postEmail as! String)
                        }
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
        cell.lblNaam.text = "\(naamData[indexPath.row]), \(leeftijdData[indexPath.row])"
        cell.lblNiveau.text = "Niveau: \(niveauData[indexPath.row])"
        cell.lblAfstand.text = afstandData[indexPath.row]
        cell.imageProfile.image = UIImage(named: "apple-class-conference-7102.png")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentUserChatId = users[indexPath.row].uid
        
        let vcChat = ChatViewController()
        vcChat.commonInit(users[indexPath.row].username)
        vcChat.commonInit2(naam: naamData[indexPath.item],
                           onderwerp: achterData[indexPath.item],
                           datum: niveauData[indexPath.item],
                           taal: afstandData[indexPath.item],
                           beschrijving: beschrijvingData[indexPath.item])
        
//        let vc = DetailVC()
//                vc.commonInit("\(naamData[indexPath.item]) \(achterData[indexPath.item])")
//        vc.dataCommonInit(naam: "\(naamData[indexPath.item]) \(achterData[indexPath.item])",
//                       niveau: "Niveau: \(niveauData[indexPath.row])",
//                       afstand: afstandData[indexPath.item],
//                       beschrijving: beschrijvingData[indexPath.item]
//        )
        
        
//        self.navigationController?.pushViewController(vc, animated: true)
//        self.tableView.deselectRow(at: indexPath, animated: true)
    }
}

