//
//  LoginViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Yuri Shkoda on 5/24/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import CoreData
import Parse

class LoginVC: UIViewController, UITextFieldDelegate {
    
    var isLogin: Bool = true
    
    @IBOutlet weak var accountNameTF: UITextField!
    @IBOutlet weak var warehouseNameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var secondPasswordTF: UITextField!
    @IBOutlet weak var loginCreateButton: UIButton!
    @IBOutlet weak var switchModeButton: UIButton!
    @IBOutlet weak var alertLabel: UILabel!
    
    @IBAction func switchModeButtonClicked(_ sender: Any) {
        
        accountNameTF.layer.borderWidth = 0
        warehouseNameTF.layer.borderWidth = 0
        passwordTF.layer.borderWidth = 0
        secondPasswordTF.layer.borderWidth = 0
        
        alertLabel.isHidden = true
        
        if isLogin {
            
            isLogin = false
            
            secondPasswordTF.isHidden = false
            
            loginCreateButton.setTitle("Sign up", for: [])
            
            switchModeButton.setTitle("or log in", for: [])
            
        } else {
            
            isLogin = true
            
            secondPasswordTF.isHidden = true
            
            loginCreateButton.setTitle("Log in", for: [])
            
            switchModeButton.setTitle("or sign up", for: [])
        }
    }
    
    @IBAction func loginCreateButtonClicked(_ sender: Any) {
        
        var readyForSegue = true
        var pass = ""
        
        for subView in self.view.subviews as [UIView] {
            
            if let textField = subView as? UITextField {
                
                if textField.text == "" && textField.isHidden == false {
                    textField.layer.borderWidth = 1
                    readyForSegue = false
                } else if textField.isSecureTextEntry && textField.isHidden == false {
                    if pass == "" {
                        pass = textField.text!
                    } else if textField.text != pass {
                        alertLabel.text = "Passwords are not equel"
                        alertLabel.isHidden = false
                        readyForSegue = false
                    }
                }
            }
        }
        
        if readyForSegue {
            
            
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            if isLogin {
                
                let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
                request.returnsObjectsAsFaults = false
                //TODO: also need to check password
                request.predicate = NSPredicate(format: "name = %@ AND password = %@", accountNameTF.text!, passwordTF.text!)
                
                do {
                    let results = try context.fetch(request)
                    if results.count > 0 {
                        for result in results as! [NSManagedObject]{
                            if let name = result.value(forKey: "name") as? String {
                                print("\(name) logged in")
                                self.performSegue(withIdentifier: "showSettingsSegue", sender: self)
                            }
                        }
                    } else {
                        
                        alertLabel.text = "User not found, please try again"
                        alertLabel.isHidden = false
                    }
                    
                } catch  {
                    print("Error while fetching users")
                }
                
            } else {
                
                if let accountName = accountNameTF.text, let password = passwordTF.text, let warehouseName = warehouseNameTF.text {
                
                    
                    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
                    request.returnsObjectsAsFaults = false
                    
                    request.predicate = NSPredicate(format: "name = %@ AND warehouseName = %@", [accountName, warehouseName])
                    
                    
                    do {
                        let results = try context.fetch(request)
                        if results.count > 0 {
                            for result in results as! [NSManagedObject] {
                                
                                if let name = result.value(forKey: "name") as? String {
                                    self.alertLabel.text = "User \(name) already exists in \(warehouseName)"
                                    self.alertLabel.isHidden = false
                                }
                            }
                            
                        } else {
                            
                            let newUser = NSEntityDescription.insertNewObject(forEntityName: "Users", into: context)
                            
                            newUser.setValue(accountName, forKey: "name")
                            newUser.setValue(warehouseName, forKey: "warehouseName")
                            newUser.setValue(password, forKey: "password")
                            
                            do {
                                try context.save()
                                
                                let query = PFQuery(className: "iWarehouse_settings")
                                
                                query.whereKey("WarehouseName", equalTo: "iWarehouse_defaults")
                                
                                query.findObjectsInBackground(block: { (objects, error) in
                                    
                                    if objects != nil {
                                    
                                        if let objects = objects {
                                            
                                            if objects.count > 0 {
                                                
                                                for defaultSettings in objects {
                                                    
                                                    let placeholders = defaultSettings["Placeholders"]
                                                    let settingsFields = defaultSettings["Settings"]
                                                    let settingsToSave = NSEntityDescription.insertNewObject(forEntityName: "Settings", into: context)
                                                    
                                                    settingsToSave.setValue(placeholders, forKey: "placeholders")
                                                    settingsToSave.setValue(settingsFields, forKey: "settingsFields")
                                                    settingsToSave.setValue(warehouseName, forKey: "warehouseName")
                                                    
                                                    let propertyToSave = NSEntityDescription.insertNewObject(forEntityName: "Properties", into: context)
                                                    
                                                    propertyToSave.setValue("Location", forKey: "property")
                                                    propertyToSave.setValue([], forKey: "defaults")
                                                    propertyToSave.setValue(accountName, forKey: "warehouseName")
                                                    
                                                    let item = PFObject(className: "iWarehouse_settings")
                                                    
                                                    item["Placeholders"] = placeholders
                                                    item["Settings"] = settingsFields
                                                    item["WarehouseName"] = warehouseName
                                                    item["Properties"] = ["Location": []]
                                                    
                                                    
                                                    let acl = PFACL()
                                                    
                                                    acl.getPublicReadAccess = true
                                                    acl.getPublicWriteAccess = true
                                                    item.acl = acl
                                                    
                                                    item.saveInBackground(block: { (success, error) in
                                                    
                                                        if success {
                                                            do {
                                                                try context.save()
                                                                print("default settings saved")
                                                            } catch {
                                                                print("error while saving default settings to CoreData")
                                                            }
                                                        } else {
                                                            print("error while saving default settings to Parse")
                                                        }
                                                    })
                                                }
                                            }
                                        }
                                    }
                                })
                            } catch {
                                //TODO: add error catching
                            }
                        }
                    } catch {
                        //TODO: add error catching
                    }
                }
            }
        } else {
            if alertLabel.isHidden {
                alertLabel.text = "all fields are requered!"
                alertLabel.isHidden = false
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for subView in self.view.subviews as [UIView] {
            if let tf = subView as? UITextField {
                tf.delegate = self
            }
        }
        
        accountNameTF.layer.borderColor = UIColor.red.cgColor
        warehouseNameTF.layer.borderColor = UIColor.red.cgColor
        passwordTF.layer.borderColor = UIColor.red.cgColor
        secondPasswordTF.layer.borderColor = UIColor.red.cgColor
        
        if isLogin {
        
            secondPasswordTF.isHidden = true
            alertLabel.isHidden = true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
