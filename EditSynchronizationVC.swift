//
//  EditSynchronizationVC.swift
//  ParseStarterProject-Swift
//
//  Created by Yuri Shkoda on 7/13/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit

class EditSynchronizationVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let pickerAr: [String] = ["immediately", "every hour", "every 4 hours", "every 8 hours", "every day"]
    var fromServer: Bool = true

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var label: UILabel!
    
    @IBAction func save(_ sender: Any) {
        
//        synchronization.editGetting(from: textField.text!, every: 1)
        
        if let url = textField.text {
            synchronization.editSynchronization(url: url, perDay: pickerIndexToPerDay(pickerIndex: picker.selectedRow(inComponent: 0)), fromServer: fromServer)
            
            synchronization.synchronize()
            
            performSegue(withIdentifier: "backToSynchronization", sender: nil)
        }
    }
    
    func pickerIndexToPerDay(pickerIndex: Int) -> Int {
        switch pickerIndex {
        case let ind where ind == 1:
            return 24 / 1
        case let ind where ind == 2:
            return 24 / 4
        case let ind where ind == 3:
            return 24 / 8
        case let ind where ind == 4:
            return 24 / 24
        default:
            return 0
        }
    }
    
    func perDayToPickerIndex(perDay: Int) -> Int {
        switch perDay {
        case let pD where pD == 1:
            return 4
        case let pD where pD == 3:
            return 3
        case let pD where pD == 6:
            return 2
        case let pD where pD == 24:
            return 1
        default:
            return 0
        }
    }
    
    let synchronization = Synchronization()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let synchronizationSettings = synchronization.getSynchronizationSettings(fromServer: fromServer)
        textField.text = synchronizationSettings.0
        label.text = label.text! + pickerAr[perDayToPickerIndex(perDay: synchronizationSettings.1)]
        picker.selectRow(perDayToPickerIndex(perDay: synchronizationSettings.1), inComponent: 0, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerAr.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerAr[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        label.text = "Update \(pickerAr[row])"
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        let myTitle = NSAttributedString(string: pickerAr[row], attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 15.0)!,NSForegroundColorAttributeName:UIColor.darkGray])
        return myTitle
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
