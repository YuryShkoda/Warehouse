//
//  WarehouseItem.swift
//  ParseStarterProject-Swift
//
//  Created by Yuri Shkoda on 7/7/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import CoreData
import Parse

class WarehouseItem {
    
    let model: String
    
    init(model: String){
        self.model = model
    }
    
    func addItemToWarehouse(){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Warehouse")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "model == %@", self.model)
        
        do {
            let results = try context.fetch(request)
            
            if results.count > 0 {
                for item in results as! [NSManagedObject] {
                    print("\(item) will be changed")
                }
                
            } else {
                let newItem = NSEntityDescription.insertNewObject(forEntityName: "Warehouse", into: context)
                newItem.setValue(self.model, forKey: "model")
                newItem.setValue("xxxxxx", forKey: "newAttribute")
                
                do {
                    try context.save()
                    print("New item saved to Warehouse")
                } catch {
                    print("error while saving new Item")
                }
            }
        } catch {
            print("error while getting items by model")
        }
    }

}
