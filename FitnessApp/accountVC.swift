//
//  accountVC.swift
//  FitnessApp
//
//  Created by issd on 19/12/2018.
//  Copyright © 2018 Fontys. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class accountVC: UIViewController {
    
    @IBOutlet weak var naamLabel: UILabel!
    @IBOutlet weak var niveauLabel: UILabel!
    @IBOutlet weak var beschrijvingText: UITextView!
    @IBOutlet weak var saveButton: UIButton!
    
    var ref: DatabaseReference!
    var ref2: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()

        //accountfunctie
        let user = Auth.auth().currentUser
        if let user = user {
            let uid = user.uid
            let email = user.email
            print("uid: \(uid)")
            print("email: \(email!)")
            
            self.ref2 = Database.database().reference().child("Users")
            let query = self.ref2.queryOrdered(byChild: "userEmail").queryEqual(toValue: email)
            query.observe(.value, with: { (snapshot) in
                for user_child in (snapshot.children) {
                    let user_snap = user_child as! DataSnapshot
                    let dict = user_snap.value as! [String: String?]
                    
                    // DEFINE VARIABLES FOR LABELS
                    let voorNaam = dict["userNaam"] as? String
                    let achterNaam = dict["userAchternaam"] as? String
                    let beschrijving = dict["userBeschrijving"] as? String
                    let niveau = dict["userNiveau"] as? String
                    
//                    print("voornaam: \(voorNaam) achternaam: \(achterNaam)")
                    
                    self.naamLabel.text = "\(voorNaam!) \(achterNaam!)"
//                    self.beschrijvingLabel.text = beschrijving
                    self.niveauLabel.text = niveau
                    self.beschrijvingText.text = beschrijving
//                    [self.beschrijvingLabel .sizeToFit()]
                }
            })
        }
        self.hideKeyboardWhenTappedAround()
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(accountVC.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func postEdit(_ sender: Any) {
        let inputBeschrijving = self.beschrijvingText.text
        let user = Auth.auth().currentUser
        if let user = user {
            let uid = user.uid
            let email = user.email
            print("user-id: \(uid)")
            
            let query = self.ref2.queryOrdered(byChild: "userEmail").queryEqual(toValue: email)
            query.observe(.value, with: { (snapshot) in
                for user_child in (snapshot.children) {
                    let snap = user_child as! DataSnapshot
                    let key = snap.key
                    
                    self.ref.child("Users/\(key)/userBeschrijving").setValue(inputBeschrijving)
                }
            })
        }
        _ = navigationController?.popViewController(animated: true)
        }
    
    @IBAction func logOutButton(_ sender: Any) {
        try! Auth.auth().signOut()
        if let storyboard = self.storyboard {
            let vc = storyboard.instantiateViewController(withIdentifier: "firstNavigationController") as! UITabBarController
            self.present(vc, animated: false, completion: nil)
        }
    }
    }

