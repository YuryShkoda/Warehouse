//
//  SettingsViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Yuri Shkoda on 5/27/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var settingsTable: UITableView!
    
    var warehouse = WarehouseData()
    
    var placeHolders: [String] = []
    
    var changeName: Bool = false
    var newName: String = ""
    var isFirstFieldAnabled: Bool = true
    
    var isSecureEntry: Bool = false
    var curPass: String = ""
    var newPass: String = ""
    
    var createNewField: Bool = false
    var newField: String = ""
    
    var manageField: String = ""
    var fieldToSave: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshSettings), name: Notification.Name("refreshSettings"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(createAlert(_:)), name: Notification.Name("createAlert"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(manageFields(_:)), name: NSNotification.Name("manageFields"), object: nil)
        
        warehouse.getSettingsCD(refresh: nil)
        
        if newField != "" {
            
            self.warehouse.saveSettingsCD(addData: newField)
            newField = ""
            
        } else if newName != "" {
        
            warehouse.changeNameCD (newName: newName)
            newName = ""
        
        } else if curPass != "" && newPass != "" {
        
            warehouse.changePasswordCD(currentPassword: curPass, newPassword: newPass)
            curPass = ""
            newPass = ""
            
        } else if fieldToSave.count != 0 {
            
            warehouse.saveFieldCD(property: manageField,defaults: fieldToSave)
            fieldToSave = []
            manageField = ""
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        warehouse.getSettings(refresh: true)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "changeSettingSegue" {
            if let changeSettingsVC = segue.destination as? ChangeSettingsVC {
                
                changeSettingsVC.placeHolders = self.placeHolders
                changeSettingsVC.isFirstFieldAnabled = self.isFirstFieldAnabled
                changeSettingsVC.isSecureEntry = self.isSecureEntry
                changeSettingsVC.createNewField = self.createNewField
                changeSettingsVC.changeName = self.changeName
            }
        } else if segue.identifier == "manageFieldsSegue" {
        
            if let fieldVC = segue.destination as? FieldVC {
            
                fieldVC.parentFieldName = self.manageField
                
                if self.warehouse.settingsFields[manageField] != nil {
                    fieldVC.childFields = self.warehouse.settingsFields[manageField]!
                } 
            }
        }
    }
    
    func refreshSettings(){
    
        settingsTable.reloadData()
    }
    
    func manageFields(_ notification: NSNotification){
    
        performSegue(withIdentifier: "manageFieldsSegue", sender: nil)
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        
//        print("section = \(warehouse.settings[section][0][0])")
        return warehouse.settings[section][0][0]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return warehouse.settings.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return warehouse.settings[section][1].count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) {
            
            switch cell.tag {
            case 1:
                self.placeHolders = warehouse.settingsPlaceHolders[indexPath.section][indexPath.row]
                
                if indexPath.row == 0 {
                    
                    self.isFirstFieldAnabled = false
                    self.placeHolders[0] = warehouse.name
                    self.changeName = true
                    
                } else {
                    self.isSecureEntry = true
                }
                
                performSegue(withIdentifier: "changeSettingSegue", sender: nil)
            case 2:
                
                if let fieldName = cell.textLabel?.text { self.manageField = fieldName }
                performSegue(withIdentifier: "manageFieldsSegue", sender: nil)
            case 3:
                self.placeHolders = warehouse.settingsPlaceHolders[indexPath.section][0]
                self.createNewField = true
                performSegue(withIdentifier: "changeSettingSegue", sender: nil)
            default:
                warehouse.logOut()
                performSegue(withIdentifier: "logOutSegue", sender: nil)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        
        cell.textLabel?.text = warehouse.settings[indexPath.section][1][indexPath.row]
        
        if indexPath.section == 0 {
            
            cell.tag = 1
        
        } else if indexPath.section == 1 {
            
            cell.tag = 2
        
            if cell.textLabel?.text == "Add field" {
                cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
                cell.tag = 3
            }
        } else {
            
            cell.tag = 4
        }
 
        return cell
    }
    
    func createAlert(_ notification: NSNotification) {
        
        if let title = notification.userInfo?["Title"] as? String {
            if let message = notification.userInfo?["Message"] as? String {
                let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                    
                    self.dismiss(animated: true, completion: nil)
                }))
                
                self.present(alert, animated: true, completion: nil)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
