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
    
    @IBOutlet weak var signInLabel: UILabel!
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    
    @IBOutlet weak var signInButton: UIButton!
    
//    var isSignIn:Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func signInSelectorChanged(_ sender: UISegmentedControl) {
        //signIn bool naar false zetten (flip the boolean)
        isSignIn = !isSignIn
        
        //check the bool and set te labels
        if isSignIn {
            signInLabel.text = "Sign in"
            signInButton.setTitle("Sign in", for: .normal)
        } else {
            signInLabel.text = "register"
            signInButton.setTitle("Register", for: .normal)
        }
    }
    
    @IBAction func signInButtonTapped(_ sender: Any) {
        //email validation
        if let email = emailInput.text, let pass = passwordInput.text{
            
            //check if it's sign in or register
            if isSignIn {
                //sign in the user
                Auth.auth().signIn(withEmail: email, password: pass) { (user, error) in
                    
                    if let u = user {
                        //user is found, go to home screen
                        self.performSegue(withIdentifier: "goToHome", sender: self)
                    }
                    else {
                        //error: check error
                    }
                }
            } else {
                //register the user
                Auth.auth().createUser(withEmail: email, password: pass) { (authResult, error) in
                    // ...
                    if let user = authResult?.user {
                        self.performSegue(withIdentifier: "goToHome", sender: self)
                    } else {
                        return
                    }
                }
            }
        }
    }
}
