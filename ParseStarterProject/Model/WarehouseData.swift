
//
//  WorehouseData.swift
//  ParseStarterProject-Swift
//
//  Created by Yuri Shkoda on 5/30/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import Parse

class WarehouseData {

    var name: String
    
    var list:[Int: [String]] = [:]
    
    var settings: [[[String]]] = []
    var settingsPlaceHolders: [[[String]]] = []
    var settingsFields: [String: [String]] = [:]
//    {"Field":["1","2"]}
    
    init(){
        
        let user = PFUser.current()
        self.name = (user?.username!)!
    }
    
    func getSettings(refresh: Bool?){
    
        let query = PFQuery(className: "Settings")
        
        query.whereKey("Warehouse", equalTo: self.name)
        
        query.findObjectsInBackground { (objects, error) in
            
            if let objects = objects {
                
                if objects.count > 0 {
                  
                    let warehouseSettings = objects[0]
                    self.settings = warehouseSettings["Settings"] as! [[[String]]]
                    self.settingsPlaceHolders = warehouseSettings["SettingsPlaceHolders"] as! [[[String]]]
                    self.settingsFields = warehouseSettings["SettingsFields"] as! [String : [String]]
                    
                    if let _ = refresh {
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshSettings"), object: nil)
                    }
                }
            }
        }
    }
    
    func saveSettings(addData: String?){
        
        //FIXME: this method has to be refactored
        
        if settings.count == 0 {
            getSettings(refresh: nil)
        }
    
        let query = PFQuery(className: "Settings")
        
        query.whereKey("Warehouse", equalTo: self.name)
        
        query.findObjectsInBackground { (objects, error) in
            
            if let objects = objects {
            
                if objects.count == 0 {
                
                    let item = PFObject(className: "Settings")
                    
                    item["Warehouse"] = self.name
                    
                    if let addData = addData { self.settings[1][1].insert(addData, at: 0) }
                    
                    item["Settings"] = self.settings
                    
                    item.saveInBackground()
                
                } else {
                
                    let object = objects[0]
                    
                    if let addData = addData {
                        
                        self.settings[1][1].insert(addData, at: 0)
                    
                    }
                            
                    object["Settings"] = self.settings
                    
                    
                    object.saveInBackground()
                }
            }
        }
    }
    
    func addField(fieldName: String) {
    
        let query = PFQuery(className: "Settings")
        
        query.whereKey("Warehouse", equalTo: self.name)
        
        query.findObjectsInBackground { (objects, error) in
            
            if let objects = objects {
                
                if objects.count > 0 {
                    
                    let warehouseSettings = objects[0]
                        
                    var setAr = warehouseSettings["Settings"] as! [[[String]]]
                        
                    setAr[1][1].insert(fieldName, at: 0)
                    
                    warehouseSettings["Settings"] = setAr
                    
                    warehouseSettings.saveInBackground(block: { (success, error) in
                        if success {
                            //TODO: add notification
                            print("Settings saved!")
                        } else {
                            print("Error")
                        }
                    })
                }
            }
        }
    }
    
    func getCount() -> Int {
    
        if self.list.count == 0 {
            
            return 0
        
        } else {
        
            return 1
        }
    
    }
    
    func getData() {
    
        let query = PFQuery(className: self.name)
    
        query.findObjectsInBackground (block: { (objects, error) in
                
            if let items = objects {
                    
                if items.count > 0 {
                        
                    for item in items {
                            
                        let supInd = item["IndexOfSuper"] as! Int
                            
                        let itemDescription = item["Model"] as! String
                            
                        if let ind = self.list.index(forKey: supInd) {
                                
                            var val = self.list[ind].value
                                
                            val.append(itemDescription)
                                
                            self.list.updateValue(val, forKey: supInd)
                                
                        } else {
                                
                            self.list[supInd] = [itemDescription]
                        }
                    }
                        
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshMyTableView"), object: nil)
                }
                    
            } else {
                    //TODO: implement error handling
            }
        })
    }
    
    func changeName(newName: String) -> Void {
        
        let user = PFUser.current()!
        
        user["username"] = newName
        
        user.saveInBackground(block: { (success, error) in
            
            if success {
                
                let query = PFQuery(className: "Settings")
                
                query.whereKey("Warehouse", equalTo: self.name)
                
                query.findObjectsInBackground(block: { (objects, error) in
                    
                    if let settings = objects {
                    
                        if settings.count > 0 {
                        
                            for warehouseSettings in settings {
                                
                                warehouseSettings["Warehouse"] = newName
                                warehouseSettings.saveInBackground()
                                
                                self.name = newName
                            }
                        }
                    }
                })
                
            } else {
                //TODO: implement error handling
            }
        })
    }
    
    func changePassword(currentPassword: String, newPassword: String) {
    
        PFUser.logInWithUsername(inBackground: self.name, password: currentPassword) { (success, error) in
            
            if success != nil {
                
                let user = PFUser.current()
                user?.password = newPassword
                
                user?.saveInBackground(block: { (success, error) in
                    
                    if error != nil{
                        let error = error as NSError?
                        
                        var displayErrorMessage = ""
                        
                        if let errorMessage = error?.userInfo["error"] as? String {
                            
                            displayErrorMessage = errorMessage
                        }
                        var alertMessage: [String: String] = [:]
                        alertMessage["Title"] = "Connection error"
                        alertMessage["Message"] = displayErrorMessage
                        NotificationCenter.default.post(name: NSNotification.Name("createAlert"), object: nil, userInfo: alertMessage)
                    }
                })
                
            } else {
                
                let error = error as NSError?
                
                var displayErrorMessage = ""
                
                if let errorMessage = error?.userInfo["error"] as? String {
                    
                    displayErrorMessage = errorMessage
                }
                var testString: [String: String] = [:]
                testString["Title"] = "Changing password error"
                testString["Message"] = displayErrorMessage
                NotificationCenter.default.post(name: NSNotification.Name("createAlert"), object: nil, userInfo: testString)
            }
        }
    }
    
    func logOut(){
        PFUser.logOutInBackground()
    }
}



class ItemData {
    
    var parametrs = [[]]
    
    func addItem(){}
    
    func editItem(){}
    
    func deleteItem(){}

}
