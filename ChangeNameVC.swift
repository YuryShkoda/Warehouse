//
//  ChangeNameViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Yuri Shkoda on 5/27/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse

class ChangeNameVC: UIViewController {

    @IBOutlet weak var currentNameTextField: UITextField!
    @IBOutlet weak var newNameTextField: UITextField!
    
    @IBAction func saveName(_ sender: Any) {
        
        if newNameTextField.text != "" {
            
            let user = PFUser.current()!
            
            user["username"] = newNameTextField.text
            
            user.saveInBackground(block: { (success, error) in
                
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
        
            newNameTextField.layer.borderWidth = 1
            newNameTextField.layer.borderColor = UIColor.red.cgColor
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let user = PFUser.current()
       
        if user?.username != "" {
        
            currentNameTextField.text = user?.username
        }
    }
    
    func createAlert(title: String, message: String){
    
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            
            self.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
