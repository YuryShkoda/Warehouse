//
//  ChangePasswordViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Yuri Shkoda on 5/27/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse

class ChangePasswordVC: UIViewController {

    @IBOutlet weak var currentPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordReenterTextField: UITextField!
    @IBOutlet weak var alertLabel: UILabel!
    
    @IBAction func savePassword(_ sender: Any) {
        
        if currentPasswordTextField.text != ""{
            
            let user = PFUser.current()
            
            PFUser.logInWithUsername(inBackground: (user?.username!)!, password: currentPasswordTextField.text!, block: { (success, error) in
                
                if (success != nil) {
                    print("success")
                
                    if self.newPasswordTextField.text != "" && self.newPasswordReenterTextField.text != "" {
                        
                        if self.newPasswordTextField.text == self.newPasswordReenterTextField.text {
                            
                            let user = PFUser.current()
                            
                            user?.password = self.newPasswordTextField.text
                            
                            user?.saveInBackground(block: { (success, error) in
                                
                                if success {
                                    
                                    self.performSegue(withIdentifier: "backToSettings", sender: self)
                                    
                                } else if error != nil {
                                    
                                    let error = error as! NSError
                                    
                                    var displayErrorMessage = ""
                                    
                                    if let errorMessage = error.userInfo["error"] as? String {
                                        
                                        displayErrorMessage = errorMessage
                                    }
                                    
                                    self.createAlert(title: "Connection Error", message: displayErrorMessage)
                                }
                            })
                            
                        } else {
                            
                            if self.currentPasswordTextField.layer.borderWidth == 1 { self.currentPasswordTextField.layer.borderWidth = 0 }
                            
                            self.newPasswordTextField.layer.borderWidth        = 1
                            self.newPasswordReenterTextField.layer.borderWidth = 1
                            
                            self.newPasswordTextField.layer.borderColor        = UIColor.red.cgColor
                            self.newPasswordReenterTextField.layer.borderColor = UIColor.red.cgColor
                            
                            self.alertLabel.text = "Passwords are not equel"
                            
                            self.alertLabel.isHidden = false
                        }
                        
                    } else {
                        
                        self.newPasswordTextField.layer.borderWidth        = 1
                        self.newPasswordReenterTextField.layer.borderWidth = 1
                        
                        self.newPasswordTextField.layer.borderColor        = UIColor.red.cgColor
                        self.newPasswordReenterTextField.layer.borderColor = UIColor.red.cgColor
                    }
                } else if error != nil {
                    
                    
                    print("2")
                
                    let error = error as! NSError
                    
                    var displayErrorMessage = ""
                    
                    if let errorMessage = error.userInfo["error"] as? String {
                        
                        displayErrorMessage = errorMessage
                    }
                    
                    self.createAlert(title: "Connection Error", message: displayErrorMessage)
                }
            })
            
        } else {
        
            currentPasswordTextField.layer.borderWidth = 1
            currentPasswordTextField.layer.borderColor = UIColor.red.cgColor
            
            alertLabel.text = "Wrong current password"
            alertLabel.isHidden = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        alertLabel.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func createAlert(title: String, message: String){
    
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            
            self.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
}
