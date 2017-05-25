//
//  SearchViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Yuri Shkoda on 5/23/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var list      = [String]()
    var filtered  = [String]()
    var ids       = [String]()
    var model     = String()
    var kind      = String()
    var size      = String()
    var color     = String()
    var quantity  = String()
    var location  = String()
    var tableMode = "Model"
    var searchIsActive = false
    
    @IBAction func serchCancelled(_ sender: Any) {
        
        searchIsActive = false
        
        view.endEditing(true)
        
        searchBar.text = ""
        
        tableMode = "Model"
        
        getItems()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getItems()
        
        let cancelButtonAttributes: NSDictionary = [NSForegroundColorAttributeName: UIColor.white]
        
        UIBarButtonItem.appearance().setTitleTextAttributes(cancelButtonAttributes as? [String : AnyObject], for: UIControlState.normal)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        tableMode = "Model"
        
        getItems()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        searchIsActive = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
        searchIsActive = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchIsActive = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchIsActive = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filtered = list.filter({ (text) -> Bool in
            
            let tmp: NSString = text as NSString
            
            let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            
            return range.location != NSNotFound
        })
        
        if filtered.count != 0 {
        
            searchIsActive = true
        
        } else {
        
            searchIsActive = false
        }
        
        tableView.reloadData()
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchIsActive {
        
            return filtered.count
            
        } else {
        
            return list.count
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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
            break
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
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        if searchIsActive {
        
            cell.textLabel?.text = filtered[indexPath.row]
        
        } else {
        
            cell.textLabel?.text = list[indexPath.row]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        if tableMode == "Model" {
            
            return true
            
        } else {
            
            return false
            
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
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
