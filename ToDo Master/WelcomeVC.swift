//
//  WelcomeVC.swift
//  ToDo Master
//
//  Created by Daniel Springer on 19/01/2017.
//  Copyright © 2017 Daniel Springer. All rights reserved.
//

import UIKit
import Firebase

class WelcomeVC: UIViewController {

    override func viewDidLoad() {
        
        super.viewDidLoad()
        if FIRAuth.auth()?.currentUser?.uid != nil{
            login()
        }
}
func login(){
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let ProfileVC = storyboard.instantiateViewController(withIdentifier: "Profile")
    present(ProfileVC, animated: true, completion: nil)
}
}
