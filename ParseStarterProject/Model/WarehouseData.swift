
//
//  WorehouseData.swift
//  ParseStarterProject-Swift
//
//  Created by Yuri Shkoda on 5/30/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import Parse
import CoreData

class WarehouseData {

    var name: String
    
    var isFirstLoad: Bool = false
    
    var list:[Int: [String]] = [:]
    
    var settings: [[[String]]] = []
    var settingsPlaceHolders: [[[String]]] = []
    var settingsFields: [String: [String]] = [:]
    var fieldToSave: [String: [String]] = [:]
    
    init(){
        
        self.name = "default_name"
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "isLoggedIn == %@", NSNumber(booleanLiteral: true))
        
        do {
            let results = try context.fetch(request)
            
            if results.count > 0 {
                for result in results as! [NSManagedObject] {
                    if let warehouseName = result.value(forKey: "warehouseName") as? String{
                    
                        self.name = warehouseName
                    }
                }
            }
            
        } catch {
            print("error while getting warehouse name")
        }
        
//        if let user = PFUser.current() {
//            
//            self.name = user.username!
//        } else {
//            self.name = "default"
//        }
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
                    
                    
//                    self.settingsFields = warehouseSettings["SettingsFields"] as! [String : [String]]
                    
                    if let _ = refresh {
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshSettings"), object: nil)
                    }
                }
            }
        }
    }
    
    func getSettingsCD(refresh: Bool?){
    
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Settings")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "warehouseName = %@", self.name)
        
        do {
            let results = try context.fetch(request)
            if results.count > 0 {
                for result in results as! [NSManagedObject]{
                    self.settings = result.value(forKey: "settingsFields") as! [[[String]]]
                    self.settingsPlaceHolders = result.value(forKey: "placeholders") as! [[[String]]]
                }
                
                let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Properties")
                request.returnsObjectsAsFaults = false
                request.predicate = NSPredicate(format: "warehouseName = %@", self.name)
                
                do {
                    let results = try context.fetch(request)
                    if results.count > 0 {
                        for result in results as! [NSManagedObject] {
                            let setFields =  result.value(forKey: "defaults") as! [String]
                            print(setFields)
                            //if self.settingsFields.count > 0 {
                                let property = result.value(forKey: "property") as! String
                            print(property)
                                self.settingsFields[property] = setFields
                            self.settings[1][1].insert(property, at: 0)
                        }
                    }
                } catch {
                    print("error while finding properties")
                }
                
                if let _ = refresh {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshSettings"), object: nil)
                }
            }
        } catch {
            print("error while fetching request to Settings")
        }
    }
    
    func saveSettingsCD(addData: String?){
        
        //FIXME: no need to check settings.count
        //FIXME: new field has to have index = 0
        if settings.count == 0 {
            getSettingsCD(refresh: nil)
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Settings")
        request.returnsObjectsAsFaults = false
        
        request.predicate = NSPredicate(format: "warehouseName = %@", self.name)
        
        do {
            let results = try context.fetch(request)
            if results.count > 0 {
                for result in results as! [NSManagedObject] {
                    
                    if let addData = addData {
                        self.settings[1][1].insert(addData, at: 0)
                    }
                    result.setValue(self.settings, forKey: "SettingsFields")
                    
                    do {
                        try context.save()
                        print("settings saved")
                    } catch {
                        print("error while updating settings")
                    }
                }
            }
            
        } catch {
            print("error while finding settings for current warehouse")
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
    
    func saveFieldCD(property: String, defaults: [String]) -> Void {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        //TODO: stoped here
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Properties")
        request.predicate = NSPredicate(format: "property = %@", property)
        do {
            let results = try context.fetch(request)
            
            if results.count > 0 {
                for result in results as! [NSManagedObject] {
                    print(result)
                    print(defaults)
                    result.setValue(defaults, forKey: "defaults")
                    self.settingsFields[property] = defaults
                    
                    do {
                        try context.save()
                        print("new defaults saved")
                    } catch {
                        print("error while saving property")
                    }
                }
            } else {
                let newProperty = NSEntityDescription.insertNewObject(forEntityName: "Properties", into: context)
                newProperty.setValue(self.name, forKey: "warehouseName")
                newProperty.setValue(property, forKey: "property")
                newProperty.setValue(defaults, forKey: "defaults")
                
                do {
                    try context.save()
                    
                    self.settingsFields[property] = defaults
                    print("new propery saved")
                } catch {
                    print("error while saving")
                }
                
            }
        } catch  {
            print("error while finding property")
        }
    
    }
    
    func saveField(field: [String: [String]]){
        
        self.fieldToSave = field
    
        let query = PFQuery(className: "Settings")
        query.whereKey("Warehouse", equalTo: self.name)
        query.findObjectsInBackground { (objects, error) in
            
            if let objects = objects {
            
                if objects.count > 0 {
                
                    let warehouseSettings = objects[0]
                    
                    var fields = warehouseSettings["SettingsFields"] as! [String: [String]]
                    
                    print("Before \(fields)")
                    
                    for key in field.keys {
                        print(key)
                        print(field[key])
                        fields[key] = field[key]
                    }
                    print("Before \(fields)")
                    warehouseSettings["SettingsFields"] = fields
                    warehouseSettings.saveInBackground(block: { (success, error) in
                        if success {
                            print("Field saved")
                        } else {
                            print("error")
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
    
    func changeNameCD(newName: String) -> Void {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Settings")
        request.predicate = NSPredicate(format: "warehouseName = %@", self.name)
        
        do {
            let results = try context.fetch(request)
            if results.count > 0 {
                for result in results as! [NSManagedObject] {
                    print(result)
                    result.setValue(newName, forKey: "warehouseName")
                    
                    do {
                        try context.save()
                        
                        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
                        
                        do {
                            let results = try context.fetch(request)
                            if results.count > 0 {
                                for result in results as! [NSManagedObject] {
                                    result.setValue(newName, forKey: "warehouseName")
                                    
                                    do {
                                        try context.save()
                                        print("new name saved in Users")
                                        self.name = newName
                                    } catch {
                                        print("Error while changing warehouseName in Users entity")
                                    }
                                }
                            }
                        } catch {
                            print("Error while finding warehouseName in Users entity")
                        }
                        
                    } catch {
                        print("error while saving new name in settings entity")
                    }
                }
            }
        } catch {
            print("error while finding settings")
        }
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
    
    func changePasswordCD(currentPassword: String, newPassword: String) -> Void {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        request.predicate = NSPredicate(format: "password = %@ AND isLoggedIn = %@", argumentArray: [currentPassword, NSNumber(booleanLiteral: true)])
        do {
            let results = try context.fetch(request)
            if results.count > 0 {
                for result in results as! [NSManagedObject] {
                    result.setValue(newPassword, forKey: "password")
                    
                    do {
                        try context.save()
                        print("password changed")
                    } catch {
                        print("Error while saving mew password")
                    }
                }
            }
        } catch {
            print("error while finding user")
        }
    }
    
    func logOut(){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        request.predicate = NSPredicate(format: "isLoggedIn = %@", NSNumber(booleanLiteral: true))
        
        do {
            let results = try context.fetch(request)
            if results.count > 0 {
                for result in results as! [NSManagedObject]{
                    result.setValue(false, forKey: "isLoggedIn")
                }
                
                do {
                    try context.save()
                    print("User logged out")
                } catch {
                    print("error while logging out")
                }
            }
        } catch {
            print("error finding logged in users")
        }
        
        PFUser.logOutInBackground()
    }
}



class ItemData {
    
    var parametrs = [[]]
    
    func addItem(){}
    
    func editItem(){}
    
    func deleteItem(){}

}
