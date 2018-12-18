//
//  DetailVC.swift
//  BijlessApp
//
//  Created by issd on 13/12/2018.
//  Copyright © 2018 Fontys. All rights reserved.
//

import UIKit

class DetailVC: UIViewController {
    
    @IBOutlet weak var afstandLabel: UILabel!
    @IBOutlet weak var naamLabel: UILabel!
    @IBOutlet weak var niveauLabel: UILabel!
    
    @IBOutlet weak var reactieLabel: UILabel!
    @IBOutlet weak var reactieInput: UITextField!
    @IBAction func postReactie(_ sender: Any) {
        let text = reactieInput.text
        reactieLabel.text = text
        reactieInput.text = ""
    }
    
    var naamVar = String()
    var niveauVar = String()
    var afstandVar = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        naamLabel.text = naamVar
        niveauLabel.text = niveauVar
        afstandLabel.text = afstandVar
    }
    
    func commonInit(_ title: String) {
        self.title = title
    }
    
    func commonInit2(naam: String, niveau: String, afstand: String) {
        naamVar = naam
        niveauVar = niveau
        afstandVar = afstand
    }
}

