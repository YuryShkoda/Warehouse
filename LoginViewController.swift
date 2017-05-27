//
//  LoginViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Yuri Shkoda on 5/24/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {
    
    var isLogin = true

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordSecondTextField: UITextField!
    @IBOutlet weak var loginCreateButton: UIButton!
    @IBOutlet weak var switchModeButton: UIButton!
    @IBOutlet weak var alertLabel: UILabel!
    
    @IBAction func switchModeButtonClicked(_ sender: Any) {
        
        nameTextField.layer.borderWidth = 0
        passwordTextField.layer.borderWidth = 0
        passwordSecondTextField.layer.borderWidth = 0
        
        alertLabel.isHidden = true
        
        if isLogin {
            
            isLogin = false
            
            passwordSecondTextField.isHidden = false
            
            loginCreateButton.setTitle("Sign up", for: .normal)
            
            switchModeButton.setTitle("or log in", for: .normal)
            
        } else {
            
            isLogin = true
            
            passwordSecondTextField.isHidden = true
            
            loginCreateButton.setTitle("Log in", for: .normal)
            
            switchModeButton.setTitle("or sign up", for: .normal)
        }
    }
    
    @IBAction func loginCreateButtonClicked(_ sender: Any) {
        
        if isLogin {
            
            if nameTextField.text != "" && passwordTextField.text != "" {
            
                PFUser.logInWithUsername(inBackground: nameTextField.text!, password: passwordTextField.text!, block: { (user, error) in
                    
                    if error != nil {
                        
                        let error = error as NSError?
                        
                        var displayErrorMessage = ""
                        
                        if let errorMessage = error?.userInfo["error"] as? String {
                            
                            displayErrorMessage = errorMessage
                        }
                        
                        self.createAlert(title: "Connection Error", message: displayErrorMessage)
                        
                    } else {
                    
                        self.performSegue(withIdentifier: "loginSegue", sender: self)
                    }
                })
            } else {

                if nameTextField.text == "" { nameTextField.layer.borderWidth = 1 }
                if passwordTextField.text == "" { passwordTextField.layer.borderWidth = 1 }
                
                alertLabel.isHidden = false
                alertLabel.text = "All fields are requered"
            }
        
        } else {
        
            if nameTextField.text != "" && passwordTextField.text != "" && passwordSecondTextField.text != "" {
                
                if passwordTextField.text == passwordSecondTextField.text{
                    
                    let user = PFUser()
                    
                    user.username = nameTextField.text!
                    user.password = passwordTextField.text!
                    
                    let acl = PFACL()
                    
                    acl.getPublicReadAccess = true
                    acl.getPublicWriteAccess = true
                    
                    user.signUpInBackground(block: { (success, error) in
                        
                        if success {
                        
                            self.performSegue(withIdentifier: "loginSegue", sender: self)
                        
                        } else if error != nil {
                        
                            let error = error as NSError?
                            
                            var displayErrorMessage = ""
                            
                            if let errorMessage = error?.userInfo["error"] as? String {
                                
                                displayErrorMessage = errorMessage
                            }
                            
                            self.createAlert(title: "Error in a form", message: displayErrorMessage)
                        }
                    })
                
                } else{
                
                    alertLabel.text = "Passwords are not equel"
                    alertLabel.isHidden = false
                    
                    passwordTextField.layer.borderWidth = 1
                    passwordSecondTextField.layer.borderWidth = 1
                }
                
            } else {
                
                alertLabel.text = "All fields are requered!"
                alertLabel.isHidden = false
                
                if nameTextField.text == "" { nameTextField.layer.borderWidth = 1 }
                if passwordTextField.text == "" { passwordTextField.layer.borderWidth = 1 }
                if passwordSecondTextField.text == "" { passwordSecondTextField.layer.borderWidth = 1 }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameTextField.layer.borderColor = UIColor.red.cgColor
        passwordTextField.layer.borderColor = UIColor.red.cgColor
        passwordSecondTextField.layer.borderColor = UIColor.red.cgColor
        
        if isLogin {
        
            passwordSecondTextField.isHidden = true
            alertLabel.isHidden = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func createAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            
            self.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
}
