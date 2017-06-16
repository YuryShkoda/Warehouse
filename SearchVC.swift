//
//  SearchViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Yuri Shkoda on 5/23/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse

//TODO: serch has to work with new/empty fields in item description

class SearchVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var warehouse = WarehouseData()
    
    var subList = false
    
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
 
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        warehouse.getData()
        
        let cancelButtonAttributes: NSDictionary = [NSForegroundColorAttributeName: UIColor.white]
        
        UIBarButtonItem.appearance().setTitleTextAttributes(cancelButtonAttributes as? [String : AnyObject], for: UIControlState.normal)
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshList), name:NSNotification.Name(rawValue: "refreshMyTableView"), object: nil)
        
    }
    
    func refreshList () {
        
        self.tableView.reloadData()
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
        
        //FIXME: if has to check searchIsActive
        
        let count = warehouse.getCount()
            
        return count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //warehouse.getData(cellInd: nil, indexOfSuper: indexPath.row)
        
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        //cell.textLabel?.text = warehouse.getData(cellInd: indexPath.row, indexOfSuper: nil)
        
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
            
        }
    }
}
