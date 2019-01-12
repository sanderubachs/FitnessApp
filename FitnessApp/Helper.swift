//
//  Helper.swift
//  FitnessApp
//
//  Created by issd on 09/01/2019.
//  Copyright © 2019 Fontys. All rights reserved.
//

import Foundation
import UIKit

class Helper {
    
    static let helper = Helper()
    
    func switchToNavigationVC() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "feedVC") as! UINavigationController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = vc
    }
    
}
