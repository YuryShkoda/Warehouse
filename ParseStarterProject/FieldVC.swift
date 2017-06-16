//
//  FieldVC.swift
//  ParseStarterProject-Swift
//
//  Created by Yuri Shkoda on 6/14/17.
//  Copyright © 2017 Parse. All rights reserved.
//

//TODO: https://blog.apoorvmote.com/edit-uitableview-row-text-in-swift/
//FIXME: have to change view hieght when keyboard is showing

import UIKit

class FieldVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    var parentFieldName: String = ""
    var childFields: [String] = []
    var addFieldMode: Bool = true
    var fieldToEdit: Int = -1

    @IBOutlet weak var fieldsTable: UITableView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var addEditButton: UIButton!
    
    @IBAction func addOrEdit(_ sender: Any) {
        
        if textField.text == "" {
        
            textField.layer.borderWidth = 1
            textField.layer.borderColor = UIColor.red.cgColor
        
        }else if addFieldMode {
           
            childFields.append(textField.text!)
            self.fieldsTable.reloadData()
            textField.text = ""
            prepareView()
            
        } else {
            
            if fieldToEdit >= 0 {
                
                childFields[fieldToEdit] = textField.text!
                self.fieldsTable.reloadData()
                addEditButton.setTitle("Add field", for: .normal)
                addFieldMode = true
                textField.text = ""
                fieldToEdit = -1
            }
        }
    }
    
    @IBAction func saveButtonClicked(_ sender: Any) {
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fieldsTable.allowsSelection = false
        self.textField.delegate = self
    }
    
    override func viewDidLayoutSubviews(){
        
        prepareView()
    }
    
    func prepareView(){
    
        fieldsTable.frame = CGRect(x: fieldsTable.frame.origin.x, y: 0  , width: fieldsTable.frame.size.width, height: fieldsTable.contentSize.height)
        
        textField.frame = CGRect(x: textField.frame.origin.x, y: fieldsTable.frame.maxY + 50, width: textField.frame.size.width, height: textField.frame.size.height)
        
        addEditButton.frame = CGRect(x: addEditButton.frame.origin.x, y: textField.frame.maxY + 20, width: addEditButton.frame.size.width, height: addEditButton.frame.size.height)
        
        fieldsTable.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "saveFieldSegue" {
            if let settingsVC = segue.destination as? SettingsVC {
                
                settingsVC.fieldToSave[parentFieldName] = childFields
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return childFields.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { (action, index) in
            
            self.textField.text = self.childFields[indexPath.row]
            self.addEditButton.setTitle("Save", for: .normal)
            self.fieldToEdit = indexPath.row
            self.addFieldMode = false
            self.textField.becomeFirstResponder()
        }
        let delete = UITableViewRowAction(style: .default, title: "Delete") { (action, index) in
            
            self.childFields.remove(at: indexPath.row)
            self.fieldsTable.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
            self.fieldsTable.reloadData()
            self.prepareView()
        }
        
        return [delete, edit]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
        cell.textLabel?.text = childFields[indexPath.row]
        return cell
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
