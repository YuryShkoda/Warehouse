//
//  User.swift
//  ParseStarterProject-Swift
//
//  Created by Yuri Shkoda on 7/13/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class User {
    
    var warehouseName: String
    var userName: String
    
    init () {
        
        self.warehouseName = "default_name"
        self.userName = "default_name"
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "isLoggedIn = %@", NSNumber(booleanLiteral: true))
        
        do {
            let results = try context.fetch(request)
            if results.count > 0 {
                for result in results as! [NSManagedObject]{
                    if let wName = result.value(forKey: "warehouseName") as? String {
                        self.warehouseName = wName
                    }
                    if let uName = result.value(forKey: "name") as? String {
                        self.userName = uName
                    }
                }
            }
        } catch {
            print("error while geting logged in users")
        }
    }
}
