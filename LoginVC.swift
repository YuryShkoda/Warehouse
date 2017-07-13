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
    var isFirstLoad: Bool = false
    
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
                
                if let accountName = accountNameTF.text, let password = passwordTF.text, let warehouseName = warehouseNameTF.text {
                    
                    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
                    request.returnsObjectsAsFaults = false
                    
                    request.predicate = NSPredicate(format: "name = %@ AND password = %@ AND warehouseName = %@", argumentArray: [accountName, password, warehouseName])
                    
                    do {
                        let results = try context.fetch(request)
                        if results.count > 0 {
                            for result in results as! [NSManagedObject]{
                                if let name = result.value(forKey: "name") as? String {
                                    result.setValue(true, forKey: "isLoggedIn")
                                    
                                    do {
                                        try context.save()
                                        print("\(name) logged in CoreData")
                                        self.performSegue(withIdentifier: "loginSegue", sender: self)
                                    } catch {
                                        print("error while changing logged in status")
                                    }
                                    
                                    //TODO: need to determine when app will connect to Parse
//                                    PFUser.logInWithUsername(inBackground: accountName, password: password, block: { (success, error) in
//                                        if error != nil {
//                                            
//                                            let error = error as NSError?
//                                            
//                                            var displayErrorMessage = ""
//                                            
//                                            if let errorMessage = error?.userInfo["error"] as? String {
//                                                
//                                                displayErrorMessage = errorMessage
//                                            }
//                                            
//                                            self.createAlert(title: "Connection Error", message: displayErrorMessage)
//                                            
//                                        } else {
//                                            print("Logged in Parse")
//                                            self.performSegue(withIdentifier: "showSettingsSegue", sender: self)
//                                        }
//                                    })
                                }
                            }
                        } else {
                            
                            alertLabel.text = "User not found, please try again"
                            alertLabel.isHidden = false
                        }
                        
                    } catch  {
                        print("Error while fetching users")
                    }
                }
            } else {
                
                if let accountName = accountNameTF.text, let password = passwordTF.text, let warehouseName = warehouseNameTF.text {
                    
                    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
                    request.returnsObjectsAsFaults = false
                    
                    request.predicate = NSPredicate(format: "name = %@ AND warehouseName = %@",argumentArray: [accountName, warehouseName])
                    
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
                            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Settings")
                            request.returnsObjectsAsFaults = false
                            
                            request.predicate = NSPredicate(format: "warehouseName = %@", warehouseName)
                            
                            do {
                                let results = try context.fetch(request)
                                if results.count > 0 {
                                    
                                    let newUser = NSEntityDescription.insertNewObject(forEntityName: "Users", into: context)
                                    
                                    newUser.setValue(accountName, forKey: "name")
                                    newUser.setValue(warehouseName, forKey: "warehouseName")
                                    newUser.setValue(password, forKey: "password")
                                    newUser.setValue(true, forKey: "isLoggedIn")
                                    
                                    do {
                                        try context.save()
                                        print("new user \(accountName) saved")
                                        self.isFirstLoad = true
                                        self.performSegue(withIdentifier: "loginSegue", sender: nil)
                                    } catch {
                                        print("error while creating new user")
                                    }
                                
                                } else {
                                    
                                    let user = PFUser()
                                    
                                    user.username = accountName
                                    user.password = password
                                    
                                    let acl = PFACL()
                                    
                                    acl.getPublicReadAccess = true
                                    acl.getPublicWriteAccess = true
                                    
                                    user.signUpInBackground(block: { (success, error) in
                                        
                                        if error != nil {
                                            let error = error as NSError?
                                            
                                            var displayErrorMessage = ""
                                            
                                            if let errorMessage = error?.userInfo["error"] as? String {
                                                
                                                displayErrorMessage = errorMessage
                                            }
                                            
                                            self.createAlert(title: "Error in a form", message: displayErrorMessage)
                                            
                                        } else {
                                            
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
                                                                
//                                                                let propertyToSave = NSEntityDescription.insertNewObject(forEntityName: "Properties", into: context)
                                                                
//                                                                propertyToSave.setValue("Model", forKey: "property")
//                                                                propertyToSave.setValue([], forKey: "defaults")
//                                                                propertyToSave.setValue(accountName, forKey: "warehouseName")
                                                                
                                                                let item = PFObject(className: "iWarehouse_settings")
                                                                
                                                                item["Placeholders"] = placeholders
                                                                item["Settings"] = settingsFields
                                                                item["WarehouseName"] = warehouseName
//                                                                item["Properties"] = ["Model": []]
                                                                let acl = PFACL()
                                                                acl.getPublicReadAccess = true
                                                                acl.getPublicWriteAccess = true
                                                                item.acl = acl
                                                                
                                                                item.saveInBackground(block: { (success, error) in
                                                                    
                                                                    if success {
                                                                        let newUser = NSEntityDescription.insertNewObject(forEntityName: "Users", into: context)
                                                                        
                                                                        newUser.setValue(accountName, forKey: "name")
                                                                        newUser.setValue(warehouseName, forKey: "warehouseName")
                                                                        newUser.setValue(password, forKey: "password")
                                                                        newUser.setValue(true, forKey: "isLoggedIn")
                                                                        
                                                                        do {
                                                                            try context.save()
                                                                            print("default settings saved")
                                                                            self.isFirstLoad = true
                                                                            self.performSegue(withIdentifier: "loginSegue", sender: nil)
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
                                        }
                                    })
                                }
                            } catch {
                                print("errror while finding settings for warehouse")
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "loginSegue" {
            if isFirstLoad {
                let tabBar = segue.destination as! UITabBarController
                tabBar.selectedIndex = 1
            }
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
