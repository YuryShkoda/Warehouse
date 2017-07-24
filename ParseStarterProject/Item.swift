//
//  Item.swift
//  ParseStarterProject-Swift
//
//  Created by Yuri Shkoda on 7/14/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import Foundation
import CoreData
import UIKit

struct Item {
    
    let id: String
    let model: String
    let location: String
    let updated: NSDate
    let synchronized: Bool
    let warehouse: String
    
    init(id: String, model: String, location: String, updated: NSDate, synchronized: Bool, warehouse: String) {
        self.id = id
        self.model = model
        self.location = location
        self.updated = updated
        self.synchronized = synchronized
        self.warehouse = warehouse
    }
    
    func save() -> Void {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let contex = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Warehouse")
        request.returnsObjectsAsFaults = false
        
        request.predicate = NSPredicate(format: "id = %@ AND warehouse = %@", [id,warehouse])
        
        do {
            let results = try contex.fetch(request)
            if results.count > 0 {
                for result in results as! [NSManagedObject]{
                    result.setValue(id, forKey: "id")
                    result.setValue(model, forKey: "model")
                    result.setValue(location, forKey: "location")
                    result.setValue(updated, forKey: "updatedDate")
                    result.setValue(warehouse, forKey: "warehouse")
                    
                    do {
                        try contex.save()
                    } catch let Error {
                        print(Error)
                    }
                }
            } else {
                let newItem = NSEntityDescription.insertNewObject(forEntityName: "Warehouse", into: contex)
                newItem.setValue(id, forKey: "id")
                newItem.setValue(model, forKey: "model")
                newItem.setValue(location, forKey: "location")
                newItem.setValue(updated, forKey: "updatedDate")
                newItem.setValue(warehouse, forKey: "warehouse")
                
                do {
                    try contex.save()
                } catch let Error {
                    print(Error)
                }
            }
        } catch let Error {
            print(Error)
        }
        
    }
    
    func initWithId(id: String) -> Item {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let contex = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Warehouse")
        request.returnsObjectsAsFaults = false
        
        request.predicate = NSPredicate(format: "id = %@ AND warehouse = %@", [id,warehouse])
        
        do {
            let results = try contex.fetch(request)
            if results.count > 0 {
                for result in results as! [NSManagedObject]{
                    
                    //TODO: need to convert String to NSDate
                    
//                    let item = Item(id: result.value(forKey: "id") as? String, model: result.value(forKey: "model") as? String, location: result.value(forKey: "location") as? String, updated: NSDate., synchronized: <#T##Bool#>, warehouse: <#T##String#>)
                }
            }
        } catch let Error {
            print(Error)
        }
        
        
        return self
    }
}
