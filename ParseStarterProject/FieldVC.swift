//
//  FieldVC.swift
//  ParseStarterProject-Swift
//
//  Created by Yuri Shkoda on 6/14/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit

class FieldVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var parentFieldName: String = ""
    var childFields: [String] = []

    @IBOutlet weak var fieldsTable: UITableView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var addEditButton: UIButton!
    @IBAction func addEditButtonClicked(_ sender: Any) {
    }
    @IBAction func saveButtonClicked(_ sender: Any) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        fieldsTable.frame = CGRect(x: fieldsTable.frame.origin.x, y: fieldsTable.frame.origin.y, width: fieldsTable.frame.size.width, height: fieldsTable.contentSize.height)
//        
//        textField.frame = CGRect(x: textField.frame.origin.x, y: fieldsTable.frame.maxY + 50, width: textField.frame.size.width, height: textField.frame.size.height)
//        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews(){
        
        fieldsTable.frame = CGRect(x: fieldsTable.frame.origin.x, y: fieldsTable.frame.origin.y, width: fieldsTable.frame.size.width, height: fieldsTable.contentSize.height)
        
        textField.frame = CGRect(x: textField.frame.origin.x, y: fieldsTable.frame.maxY + 50, width: textField.frame.size.width, height: textField.frame.size.height)
        
        addEditButton.frame = CGRect(x: addEditButton.frame.origin.x, y: textField.frame.maxY + 20, width: addEditButton.frame.size.width, height: addEditButton.frame.size.height)
        
        fieldsTable.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return childFields.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
        cell.textLabel?.text = childFields[indexPath.row]
        print(cell.frame.height)
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
