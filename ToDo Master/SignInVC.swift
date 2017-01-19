//
//  ViewController.swift
//  ToDo Master
//
//  Created by Daniel Springer on 18/01/2017.
//  Copyright © 2017 Daniel Springer. All rights reserved.
//

import UIKit
import Firebase

class SignInVC: UIViewController {

    
    
    @IBOutlet weak var UserEmailField: UITextField!
    
    @IBOutlet weak var PasswordField: UITextField!
    
    @IBAction func GoBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func SignMeUpButton(_ sender: Any) {
        
        FIRAuth.auth()?.createUser(withEmail: UserEmailField.text!, password: PasswordField.text!, completion: { user, error in
            
            if error != nil {
            print("Create user failed")
            //self.login()
                
            }
            else {
                print("User Created")
                self.performSegue(withIdentifier: "UserCreated", sender: self)
            }
        
        })
        
    }
    func login() {
        FIRAuth.auth()?.signIn(withEmail: UserEmailField.text!, password: PasswordField.text!, completion: {
            user, error in
            
            if error != nil{
                print("Incorrect credentials")
                
            }
            else {
                print("User logged in")
            }
        })
    }
}

