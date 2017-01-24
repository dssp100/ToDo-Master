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

    //Variables
    let databaseRef = FIRDatabase.database().reference(fromURL:"https://todo-master-c5574.firebaseio.com/")
    
    //Outlets
    
    @IBOutlet weak var UserNameField: UITextField!
    @IBOutlet weak var UserEmailField: UITextField!
    @IBOutlet weak var PasswordField: UITextField!
    @IBOutlet weak var ConfirmPasswordField: UITextField!
    @IBOutlet weak var CheckButton: UIButton!
    @IBOutlet weak var SignMeUpButton: UIButton!
    @IBOutlet weak var SignInError: UIImageView!
    @IBOutlet weak var SignInSuccess: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if FIRAuth.auth()?.currentUser?.uid == nil{
            logout()
        }
    }
    
    //Actions
    @IBAction func GoBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func CheckButton(_ sender: Any) {
        self.comparePasswords()
    }
    @IBAction func SignMeUpButton(_ sender: AnyObject) {
        signup()
    }
    
    //Functions
    
    func signup(){
        guard let UserNameField = UserNameField.text else{
            print("UserNameField Issue")
            return
        }
        guard let UserEmailField = UserEmailField.text else{
            print("UserEmail issue")
            return
        }
        guard let PasswordField = PasswordField.text else{
            print("PasswordField issue")
            return
        }
        guard ConfirmPasswordField.text != nil else{
            print("ConfirmPasswordField issue")
            return
        }
        
        FIRAuth.auth()?.createUser(withEmail: UserEmailField, password: PasswordField, completion: { user, error in
            if error != nil {
                self.SignInError.isHidden = false
                print("Create user failed")
            }
            else {
                self.SignInSuccess.isHidden = false
                print("User Created")
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
                    self.performSegue(withIdentifier: "User Created", sender: self)
                })
                
            }
            guard let uid = user?.uid else{
               return
            }
            let userReference = self.databaseRef.child("user").child(uid)
            let values = ["username": UserNameField, "email": UserEmailField, "pic":"!"]
            userReference.updateChildValues(values, withCompletionBlock: { (error, ref) in
                if error != nil{
                    print("error")
                    return
                }
            })
        })
    }
    func comparePasswords() {
        guard let password = PasswordField.text,
            let confirmPassword = ConfirmPasswordField.text
            else {
                print("field errors")
                return
        }
        if password == confirmPassword {
            self.SignMeUpButton.isHidden = false
            self.CheckButton.isHidden = true
        }
}
    func logout() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let LogInVC = storyboard.instantiateViewController(withIdentifier: "Login")
        present(LogInVC, animated: true, completion: nil)
    }
}
