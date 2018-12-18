//
//  ComposeViewController.swift
//  BijlessApp
//
//  Created by issd on 13/12/2018.
//  Copyright © 2018 Fontys. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ComposeViewController: UIViewController {
    
    @IBOutlet weak var naamInput: UITextField!
    @IBOutlet weak var niveauInput: UITextField!
    @IBOutlet weak var afstandInput: UITextField!
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
    }
    
    @IBAction func addPost(_ sender: Any) {
        let inputNaam = naamInput.text
        let inputNiveau = niveauInput.text
        let inputAfstand = afstandInput.text
                
        //input in database zetten
        ref?.child("Posts").childByAutoId().setValue([
            "postNaam": inputNaam!,
            "postNiveau": inputNiveau!,
            "postAfstand": inputAfstand!,
            ])
        
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelPost(_ sender: Any) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
