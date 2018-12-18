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
    var afstandData = [String]()
    var profileData = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        ref = Database.database().reference().child("Posts")
        ref.observe(DataEventType.value, with: { (snapshot) in
            if snapshot.childrenCount>0{
                //                self.postData.removeAll()
                self.naamData.removeAll()
                self.niveauData.removeAll()
                self.afstandData.removeAll()
                
                for posts in snapshot.children.allObjects as![DataSnapshot]{
                    let postObject = posts.value as? [String: AnyObject]
                    
                    let postNaam = postObject?["postNaam"]
                    let postNiveau = postObject?["postNiveau"]
                    let postAfstand = postObject?["postAfstand"]
                    let postTitle = postObject? ["postAfstand"]
//                    let postProfile = postObject?["postProfile"]
                    
                    //                    let post = Post(id: postId as! String?, onderwerp: postNaam as! String?, naam: postOnderwerp as! String?, beschrijving: postBeschrijving as! String?, datum: postDatum as! String?, taal: postTaal as! String?)
                    
                    //                    self.postData.append(post)
                    
                    self.niveauData.append(postNiveau as! String)
                    self.naamData.append(postNaam as! String)
                    self.afstandData.append(postAfstand as! String)
                    
                    //titleSet
//                    self.title = postTitle as! String
//                    self.profileData.append(postProfile as! String)
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
        
        cell.lblNaam.text = naamData[indexPath.row]
        cell.lblNiveau.text = niveauData[indexPath.row]
        cell.lblAfstand.text = afstandData[indexPath.row]
        cell.imageProfile.image = UIImage(named: "apple-class-conference-7102.png")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailVC()
        //        vc.commonInit(postData[indexPath.item])
        vc.commonInit2(naam: naamData[indexPath.item],
                       niveau: niveauData[indexPath.item],
                       afstand: afstandData[indexPath.item]
        )
        
        self.navigationController?.pushViewController(vc, animated: true)
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
}

