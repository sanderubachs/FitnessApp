//
//  ViewController.swift
//  BijlessApp
//
//  Created by issd on 13/12/2018.
//  Copyright © 2018 Fontys. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var ref: DatabaseReference!
    
    var postData = [Post]()
    
    var niveauData = [String]()
    var naamData = [String]()
    var achterData = [String]()
    var leeftijdData = [String]()
    var beschrijvingData = [String]()
    
    var afstandData = [String]()
    
//    var profileData = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        ref = Database.database().reference().child("Users")
        ref.observe(DataEventType.value, with: { (snapshot) in
            if snapshot.childrenCount>0{
                //                self.postData.removeAll()
                self.naamData.removeAll()
                self.achterData.removeAll()
                self.niveauData.removeAll()
                self.beschrijvingData.removeAll()
                self.leeftijdData.removeAll()

//                self.afstandData.removeAll()
                
                for posts in snapshot.children.allObjects as![DataSnapshot]{
                    let postObject = posts.value as? [String: AnyObject]
                    
                    let postNaam = postObject?["userNaam"]
                    let postAchter = postObject?["userAchternaam"]
                    let postNiveau = postObject?["userNiveau"]
                    let postLeeftijd = postObject?["userLeeftijd"]
                    let postBeschrijving = postObject? ["userBeschrijving"]
                    //                    let postProfile = postObject?["postProfile"]
                    
                    self.niveauData.append(postNiveau as! String)
                    self.naamData.append(postNaam as! String)
                    self.achterData.append(postAchter as! String)
                    self.leeftijdData.append(postLeeftijd as! String)
                    self.beschrijvingData.append(postBeschrijving as! String)
                    
                    
//                    self.afstandData.append(postAfstand as! String)
                    
//                    let postNaam = postObject?["postNaam"]
//                    let postNiveau = postObject?["postNiveau"]
//                    let postAfstand = postObject?["postAfstand"]
//                    let postTitle = postObject? ["postAfstand"]
////                    let postProfile = postObject?["postProfile"]
//
//                    self.niveauData.append(postNiveau as! String)
//                    self.naamData.append(postNaam as! String)
//                    self.afstandData.append(postAfstand as! String)
                    
                }
                self.tableView.reloadData()
            }
        })
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        return postData.count
        return naamData.count
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell
//        let naamOutput = "\(naamData[indexPath.row]) \(leeftijdData[indexPath.row])"
//        cell.lblNaam.text = naamData[indexPath.row]
        cell.lblNaam.text = "\(naamData[indexPath.row]) (\(leeftijdData[indexPath.row]))"
        cell.lblNiveau.text = achterData[indexPath.row]
//        cell.lblAfstand.text = afstandData[indexPath.row]
        cell.lblAfstand.text = niveauData[indexPath.row]
        cell.imageProfile.image = UIImage(named: "apple-class-conference-7102.png")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailVC()
        //        vc.commonInit(postData[indexPath.item])
        vc.commonInit2(naam: naamData[indexPath.item],
                       niveau: niveauData[indexPath.item],
//                       afstand: afstandData[indexPath.item]
                       afstand: leeftijdData[indexPath.item]
        )
        
        self.navigationController?.pushViewController(vc, animated: true)
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
}

