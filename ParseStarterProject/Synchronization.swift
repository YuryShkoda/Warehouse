//
//  Synchronization.swift
//  ParseStarterProject-Swift
//
//  Created by Yuri Shkoda on 7/13/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import Foundation
import CoreData
import UIKit

struct Synchronization {
    
    let user = User()
    
    func synchronize () -> Bool {
        
        //MARK: getting json
        let url = URL(string: "http://api.openweathermap.org/data/2.5/weather?q=London,uk&appid=08e64df2d3f3bc0822de1f0fc22fcb2d")!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error)
            } else {
                
                if let urlContent = data {
                    
                    do {
                        let jsonResult = try JSONSerialization.jsonObject(with: urlContent, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                        
                        print(jsonResult)
                        //print(jsonResult["name"])
                        
                        //MARK: Saving new items
                        //FIXME: need to get array of items from json
//                        if let items = jsonResult["items"] as? NSArray {
//                            let date = NSDate()
//                            for item in items {
//                                let item = item as! NSDictionary
//                                let newItem = Item(id: item["id"], model: item["model"], location: item["location"], updated: date, synchronized: false, warehouse: user.warehouseName)
//                            }
//                        }
                        
                        if let description = ((jsonResult["weather"] as? NSArray)?[0] as? NSDictionary)?["description"] as? String {
                            print(description)
                        }
                    } catch {
                        print("JSON Processing Failed")
                    }
                }
            }
        }
        
        task.resume()
        
        return true
    }
    
    func editSynchronization(url: String, perDay: Int, fromServer: Bool) -> Bool {
        
        if verifyURL(url: url){
        
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Settings")
            request.predicate = NSPredicate(format: "warehouseName = %@", user.warehouseName)
            
            do {
                let results = try context.fetch(request)
                if results.count > 0 {
                    for result in results as! [NSManagedObject] {
                        
                        let date = NSDate()
                        if fromServer {
                            result.setValue(url, forKey: "getDataFrom")
                            result.setValue(perDay, forKey: "getDataPerDay")
                            result.setValue(date, forKey: "lastGotDate")
                        } else {
                            result.setValue(url, forKey: "sendDataTo")
                            result.setValue(perDay, forKey: "sendDataPerDay")
                            result.setValue(date, forKey: "lastSentDate")
                        }
                        
                        do {
                            try context.save()
                        } catch {
                            print("error while saving synch data")
                        }
                    }
                }
            } catch {
                print("error while getting settings")
            }
        }
        
        return true
    }
    
    func getSynchronizationSettings(fromServer: Bool) -> (String, Int) {
        
        var url = "https://..."
        var perDay = 0
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let requast = NSFetchRequest<NSFetchRequestResult>(entityName: "Settings")
        requast.returnsObjectsAsFaults = false
        requast.predicate = NSPredicate(format: "warehouseName = %@", user.warehouseName)
        
        do {
            let results = try context.fetch(requast)
            if results.count > 0 {
                for result in results as! [NSManagedObject] {
                    if fromServer {
                        let serverURL = result.value(forKey: "getDataFrom")
                        if serverURL != nil {
                            url = serverURL as! String
                            perDay = result.value(forKey: "getDataPerDay") as! Int
                        }
                    } else {
                        let serverURL = result.value(forKey: "sendDataTo")
                        if serverURL != nil {
                            url = serverURL as! String
                            perDay = result.value(forKey: "sendDataPerDay") as! Int
                        }
                    }
                    return (url, perDay)
                }
            }
        } catch {
            print("error while getting synch settings")
        }
        
        return (url, perDay)
    }
    
    private func verifyURL(url: String) -> Bool {
        guard let url = URL(string: url) else {
            return false
        }
        return UIApplication.shared.canOpenURL(url)
    }
    
}
