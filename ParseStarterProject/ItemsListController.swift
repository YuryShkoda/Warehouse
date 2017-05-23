//
//  ItemsListController.swift
//  ParseStarterProject-Swift
//
//  Created by Yuri Shkoda on 4/24/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse

//TODO: clean code
//FIXME: deleting last item in the list
//FIXME: hide "back" button at root list

class ItemsListController: UITableViewController {
    
    @IBAction func back(_ sender: Any) {
    
        changeMode(action: "backward", index: 1)
        
    }
    
    var list      = [String]()
    var ids       = [String]()
    var model     = String()
    var kind      = String()
    var size      = String()
    var color     = String()
    var quantity  = String()
    var location  = String()
    var tableMode = "Model"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getItems()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return list.count
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        changeMode(action: "forward", index: indexPath.row)
        
    }
    
    func getItems(){
        
        let query = PFQuery(className: "Warehouse")
        
        switch tableMode {
        case "Kind":
            query.whereKey("Model", equalTo: model)
        case "Size":
            query.whereKey("Model", equalTo: model)
            query.whereKey("Kind", equalTo: kind)
        case "Color":
            query.whereKey("Model", equalTo: model)
            query.whereKey("Kind", equalTo: kind)
            query.whereKey("Size", equalTo: size)
        case "Result":
            query.whereKey("Model", equalTo: model)
            query.whereKey("Kind", equalTo: kind)
            query.whereKey("Size", equalTo: size)
            query.whereKey("Color", equalTo: color)
        default:
            print("Yurec - krasava!")
        }
        
        
        query.findObjectsInBackground { (objects, error) in
            
            if let items = objects {
                
                if self.list.count > 0 {
                
                    self.list.removeAll()
                    
                    self.ids.removeAll()
                
                }
                
                if items.count > 1 {
                
                    for item in items {
                        
                        if self.tableMode != "Result" {
                            
                            self.ids.append(String(describing: item.objectId!))
                            
                            var newItem = true
                            
                            if item[self.tableMode] != nil {
                                
                                let itemDesc = String(describing: item[self.tableMode]!)
                                
                                if self.list.count != 0 {
                                    
                                    for i in 0...(self.list.count - 1)  {
                                        
                                        if self.list[i] == itemDesc {
                                            
                                            newItem = false
                                            
                                        }
                                    }
                                }
                                
                                if newItem {
                                    
                                    self.list.append(itemDesc)
                                    
                                }
                                
                            } else {
                                
                                self.changeMode(action: "skip", index: 1)
                                
                            }
                            
                        } else {
                            
                            if item["Quantity"] != nil { self.quantity = String(describing: item["Quantity"]!) }
                            
                            if item["Location"] != nil { self.location = String(describing: item["Location"]!) }
                            
                            self.list.append(self.location + " = " + self.quantity)
                            
                        }
                    }
                
                } else {
                
                    if items[0]["Quantity"] != nil { self.quantity = String(describing: items[0]["Quantity"]!) }
                    
                    if items[0]["Location"] != nil { self.location = String(describing: items[0]["Location"]!) }
                    
                    self.list.append(self.location + " = " + self.quantity)
                
                }
                
                self.tableView.reloadData()
                
            }
        }
    }
    
    func changeMode(action: String, index: Int) {
    
        if action == "forward" {
        
            switch tableMode {
            case "Model":
                tableMode = "Kind"
                if self.list.count != 0 { model = list[index] }
            case "Kind":
                tableMode = "Size"
                if self.list.count != 0 { kind = list[index]}
            case "Size":
                tableMode = "Color"
                if self.list.count != 0 { size = list[index] }
            case "Color":
                tableMode = "Result"
                if self.list.count != 0 { color = list[index] }
            default:
                return
            }
        
        } else if action == "backward" {
            
            switch tableMode {
            case "Kind":
                tableMode = "Model"
            case "Size":
                tableMode = "Kind"
            case "Color":
                tableMode = "Size"
            default:
                return
            }
        
        } else if action == "skip"{
        
            switch tableMode {
            case "Model":
                tableMode = "Kind"
            case "Kind":
                tableMode = "Size"
            case "Size":
                tableMode = "Color"
            case "Color":
                tableMode = "Result"
            default:
                return
            }
        }
        
        getItems()
    
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = list[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        if tableMode == "Model" {
        
            return true
        
        } else {
        
            return false
        
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
        
            let query = PFQuery(className: "Warehouse")
            
            query.getObjectInBackground(withId: ids[indexPath.row + 1], block: { (objects, error) in
                
                objects?.deleteInBackground(block: { (success, error) in
                    if success {
                    
                        print("deleted")
                        
                        self.getItems()
                    
                    } else {
                    
                        print(error)
                    
                    }
                })
                
                
            })
        
        }
        
        if editingStyle == .insert {
            
            print("insert")
            
        }
        
    }
}
