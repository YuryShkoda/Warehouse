//
//  SettingsViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Yuri Shkoda on 5/27/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let sections = ["Profile", "Floors", " "]
    let items = [["Change name", "Change password"], ["Add Floor"], ["Log out"]]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //label.isHidden = false
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return sections[section]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
    
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            
            return 2
        } else {
        
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if items[indexPath.section][indexPath.row] == "Change name" {
        
            performSegue(withIdentifier: "changeNameSegue", sender: self)
        
        } else if items[indexPath.section][indexPath.row] == "Change password" {
        
            performSegue(withIdentifier: "changePasswordSegue", sender: self)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = items[indexPath.section][indexPath.row]
        
        if indexPath.section == 1 {
        
            cell.backgroundColor = UIColor.blue
        }
        
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
