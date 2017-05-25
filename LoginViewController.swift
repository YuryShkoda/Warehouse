//
//  LoginViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Yuri Shkoda on 5/24/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    var isLogin = true

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordSecondTextField: UITextField!
    @IBOutlet weak var loginCreateButton: UIButton!
    @IBOutlet weak var switchModeButton: UIButton!
    
    @IBAction func switchModeButtonClicked(_ sender: Any) {
        
        //FIXME: fix switchMode button
        
        if isLogin {
            
            isLogin = false
            
            passwordSecondTextField.isHidden = false
            
            loginCreateButton.titleLabel?.text = "Create"
            
            switchModeButton.titleLabel?.text = "or Login"
            
        } else {
            
            isLogin = true
            
            passwordSecondTextField.isHidden = true
            
            loginCreateButton.titleLabel?.text = " Login "
            
            switchModeButton.titleLabel?.text = "or Create New"
        }
    }
    
    @IBAction func loginCreateButtonClicked(_ sender: Any) {
    }
    
    /*
    
    @IBAction func switchModeButtonClicked(_ sender: Any) {
        
        if isLogin {
        
            isLogin = false
            
            passwordSecondTextField.isHidden = false
            
            loginCreateButton.titleLabel?.text = "Create"
            
            switchModeButton.titleLabel?.text = "or Login"
            
        } else {
        
            isLogin = true
            
            passwordSecondTextField.isHidden = true
            
            loginCreateButton.titleLabel?.text = " Login "
            
            switchModeButton.titleLabel?.text = "or Create New"
        }
    }
 
    */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isLogin {
        
            passwordSecondTextField.isHidden = true
        }
        
        switchModeButton.titleLabel?.text = "Test!R"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
