//
//  ProfileVC.swift
//  ToDo Master
//
//  Created by Daniel Springer on 22/01/2017.
//  Copyright © 2017 Daniel Springer. All rights reserved.
//

import UIKit
import Firebase
import Photos

class ProfileVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //Variables
    let storageRef = FIRStorage.storage().reference()
    let databaseRef = FIRDatabase.database().reference()
    
    //Outlets
    @IBOutlet weak var UserProfileImage: UIImageView!
    @IBOutlet weak var UserNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if FIRAuth.auth()?.currentUser?.uid == nil{
            logout()
        }
        setupProfile()
        
    }
    
    //Actions
    @IBAction func AddImageButton(_ sender: Any) {
    let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(picker, animated: true, completion: nil)
    }
    

    @IBAction func SaveChangesButton(_ sender: Any) {
        saveChanges()
    }
    @IBAction func SignOutButton(_ sender: Any) {
        logout()
    }
       


    
    //Functions
    func setupProfile(){
        UserProfileImage.layer.cornerRadius = UserProfileImage.frame.size.width/2
        UserProfileImage.clipsToBounds = true
        if let uid = FIRAuth.auth()?.currentUser?.uid{
            databaseRef.child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                if let dict = snapshot.value as? [String: AnyObject]
                {
                    self.UserNameLabel.text = dict["username"] as? String
                    if let profileImageURL = dict["pic"] as? String
                    {
                        let url = URL(string: profileImageURL)
                        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                            if error != nil{
                                print(error!)
                                return
                            }
                            DispatchQueue.main.async {
                                self.UserProfileImage?.image = UIImage(data: data!)
                            }
                        }).resume()
                    }
                }
            })
            
        }
    }
    func logout(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = storyboard.instantiateViewController(withIdentifier: "login")
        present(loginViewController, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage{
            selectedImageFromPicker = editedImage
        }else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            selectedImageFromPicker = originalImage
        }
        if let selectedImage = selectedImageFromPicker{
            UserProfileImage.image = selectedImage
        }
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func saveChanges(){
        
        let imageName = NSUUID().uuidString
        
        let storedImage = storageRef.child("UserProfileImages").child(imageName)
        
        if let uploadData = UIImagePNGRepresentation(self.UserProfileImage.image!)
        {
            storedImage.put(uploadData, metadata: nil, completion: { (metadata, error) in
                if error != nil{
                    print(error!)
                    return
                }
                storedImage.downloadURL(completion: { (url, error) in
                    if error != nil{
                        print(error!)
                        return
                    }
                    if let urlText = url?.absoluteString{
                        self.databaseRef.child("users").child((FIRAuth.auth()?.currentUser?.uid)!).updateChildValues(["pic" : urlText], withCompletionBlock: { (error, ref) in
                            if error != nil{
                                print(error!)
                                return
                            }
                        })                    }
                })
            })
        }
    }
}
