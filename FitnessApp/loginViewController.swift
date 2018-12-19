//
//  loginViewController.swift
//  FitnessApp
//
//  Created by issd on 18/12/2018.
//  Copyright © 2018 Fontys. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth

class loginViewController: UIViewController {
    
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    
    @IBOutlet weak var signInButton: UIButton!
    
//    var isSignIn:Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func signInButtonTapped(_ sender: Any) {
        //email validation
        if let email = emailInput.text, let pass = passwordInput.text{

            //check if it's sign in or register
                //sign in the user
                Auth.auth().signIn(withEmail: email, password: pass) { (user, error) in

                    if let u = user {
                        //user is found, go to home screen
                        self.performSegue(withIdentifier: "goToHome", sender: self)
                        
//                        print("user: \(user)")
//                        print("email: \(email)")
//                        print("pass: \(pass)")
                    }
                    else {
                        //error: check error
                    }
            }
        }
    }
}
