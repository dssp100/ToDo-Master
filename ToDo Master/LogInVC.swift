//
//  LogInVC.swift
//  ToDo Master
//
//  Created by Daniel Springer on 19/01/2017.
//  Copyright © 2017 Daniel Springer. All rights reserved.
//

import UIKit
import Firebase

class LogInVC: UIViewController {
    //Variables
    
    //Outlets
    @IBOutlet weak var UserEmailField: UITextField!
    @IBOutlet weak var UserPaswordField: UITextField!
    @IBOutlet weak var LogInError: UIImageView!
    @IBOutlet weak var LogInSuccess: UIImageView!
    
    override func viewDidLoad() {

    }

    //Actions
    @IBAction func LogMeInButton(_ sender: Any) {
        
        FIRAuth.auth()?.signIn(withEmail: UserEmailField.text!, password: UserPaswordField.text!, completion: {
            
            user, error in
            
            if error != nil{
                self.LogInError.isHidden = false
                print("Incorrect credentials")
                
            }
            else {
                self.LogInSuccess.isHidden = false
                print("User logged in")
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
                    self.performSegue(withIdentifier: "ImportPhoto", sender: self)
                })
            }
        })
    }
    //Functions

}

