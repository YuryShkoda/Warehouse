/**
* Copyright (c) 2015-present, Parse, LLC.
* All rights reserved.
*
* This source code is licensed under the BSD-style license found in the
* LICENSE file in the root directory of this source tree. An additional grant
* of patent rights can be found in the PATENTS file in the same directory.
*/

import UIKit
import CoreData
import Parse

//TODO: add saving states of pickers
//TODO: clean code
//FIXME: correct views mooving (by the bottom edge of the picker)
//FIXME: fix unknowen quantity
//FIXME: by clicling buttons keypad should return
//TODO: add left/rigt to picker

class ViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var kinds = ["Table", "Bed", "Chest", "Dresser", "Double Dresser", "Night Stand", "Mirror", "Mirror for Dresser", "Mirror for DDresser", "Chair", "Arm-Chair", "Side-Chair", "1 Door Vetrine", "2 Doors Vetrine", "4 Doors Vetrine", "4 Doors Buffet", "4 Doors Wardrobe", "LCD", ]
    var sizeColorQuantityAr = [["KS", "QS", "Left","Right", "120", "150"], ["XZ", "Walnut", "Whight", "Ivory", "Birch", "Gold", "Black"], ["XZ", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20"]]
    var locationAr = [["1", "2", "3", "4"], ["Right", "Left"], ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20"], ["Bottom", "Top"]]
    var kindSelection = ""
    var sizeColorQuantitySelection = ["", "", ""]
    var locationSelection = ["", "", "", ""]
    
    @IBOutlet weak var modelTextField: UITextField!
    @IBOutlet weak var kindTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var sizeTextField: UITextField!
    @IBOutlet weak var colorTextField: UITextField!
    @IBOutlet weak var quantityTextField: UITextField!
    @IBOutlet weak var alertLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var selectKindButton: UIButton!
    @IBOutlet weak var selectSizeColorQuantityButton: UIButton!
    @IBOutlet weak var selectLocationButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var kindsPicker: UIPickerView!
    @IBOutlet weak var sizeColorQuantityPicker: UIPickerView!
    @IBOutlet weak var locationPicker: UIPickerView!
    
    @IBAction func selectSizeColorQuantity(_ sender: Any) {
        
        if selectSizeColorQuantityButton.titleLabel?.text == "Select" {
        
            sizeColorQuantityPicker.isHidden = false

            if let locationView = self.view.viewWithTag(3) {
                
                locationView.frame = CGRect(x: locationView.frame.minX, y: sizeColorQuantityPicker.frame.maxY, width: locationView.frame.width, height: locationView.frame.height)
            }
            
            selectSizeColorQuantityButton.setTitle("Save", for: .normal)
            
            sizeColorQuantitySelection[0] = sizeColorQuantityAr[0][sizeColorQuantityPicker.selectedRow(inComponent: 0)]
            sizeColorQuantitySelection[1] = sizeColorQuantityAr[1][sizeColorQuantityPicker.selectedRow(inComponent: 1)]
            sizeColorQuantitySelection[2] = sizeColorQuantityAr[2][sizeColorQuantityPicker.selectedRow(inComponent: 2)]
        
        } else {
        
            sizeColorQuantityPicker.isHidden = true
            
            selectSizeColorQuantityButton.setTitle("Select", for: .normal)
            
            sizeTextField.text = sizeColorQuantitySelection[0]
            colorTextField.text = sizeColorQuantitySelection[1]
            quantityTextField.text = sizeColorQuantitySelection[2]
            
            sizeColorQuantitySelection = ["", "", ""]
            
            if let locationView = self.view.viewWithTag(3) {
                
                locationView.frame = CGRect(x: locationView.frame.minX, y: sizeColorQuantityPicker.frame.minY, width: locationView.frame.width, height: locationView.frame.height)
            }
        }
    }
    
    @IBAction func selectKind(_ sender: Any) {
        
        if selectKindButton.titleLabel?.text == "Select" {
            
            kindsPicker.isHidden = false
            
            if let sizeColorQuantityView = self.view.viewWithTag(2) {
                
                sizeColorQuantityView.frame = CGRect(x: sizeColorQuantityView.frame.minX, y: kindTextField.frame.maxY + sizeColorQuantityPicker.frame.height, width: sizeColorQuantityView.frame.width, height: sizeColorQuantityView.frame.height)
            }
            
            selectKindButton.setTitle("Save", for: .normal)
            
            kindSelection = kinds[kindsPicker.selectedRow(inComponent: 0)]
            
        } else {
        
            kindsPicker.isHidden = true
            
            selectKindButton.setTitle("Select", for: .normal)
            
            kindTextField.text = kindSelection
            
            kindSelection = ""
            
            
            if let sizeColorQuantityView = self.view.viewWithTag(2) {
                
                sizeColorQuantityView.frame = CGRect(x: sizeColorQuantityView.frame.minX, y: sizeColorQuantityView.frame.minY - sizeColorQuantityPicker.frame.height, width: sizeColorQuantityView.frame.width, height: sizeColorQuantityView.frame.height)
            }
        }
    }
    
    @IBAction func selectLocation(_ sender: Any) {
        
        if selectLocationButton.titleLabel?.text == "Select" {
            
            locationPicker.isHidden = false
            
            if let locationView = self.view.viewWithTag(4) {
                
                locationView.frame = CGRect(x: locationView.frame.minX, y: locationPicker.frame.maxY, width: locationView.frame.width, height: locationView.frame.height)
            }
            
            selectLocationButton.setTitle("Save", for: .normal)
            
            locationSelection[0] = locationAr[0][locationPicker.selectedRow(inComponent: 0)]
            locationSelection[1] = locationAr[1][locationPicker.selectedRow(inComponent: 1)]
            locationSelection[2] = locationAr[2][locationPicker.selectedRow(inComponent: 2)]
            locationSelection[3] = locationAr[3][locationPicker.selectedRow(inComponent: 3)]
        
        } else {
        
            locationPicker.isHidden = true
            
            selectLocationButton.setTitle("Select", for: .normal)
            
            locationTextField.text = "\(locationSelection[0]) Row, \(locationSelection[1]), \(locationSelection[2]) Unit, \(locationSelection[3])"
            
            locationSelection = ["", "", "", ""]
            
            if let locationView = self.view.viewWithTag(4) {
                
                locationView.frame = CGRect(x: locationView.frame.minX, y: locationPicker.frame.minY, width: locationView.frame.width, height: locationView.frame.height)
            }
        
        }
    }
    
    @IBAction func addItem(_ sender: Any) {
        
        if modelTextField.text != "" && kindTextField.text != "" && locationTextField.text != "" {
        
            let item = PFObject(className: "Warehouse")
            
            item["Model"] = modelTextField.text
            item["Kind"] = kindTextField.text
            item["Size"] = sizeTextField.text
            item["Color"] = colorTextField.text
            item["Quantity"] = quantityTextField.text
            item["Location"] = locationTextField.text
            
            let acl = PFACL()
            
            acl.getPublicReadAccess  = true
            acl.getPublicWriteAccess = true
            
            item.acl = acl
            
            item.saveInBackground { (success, error) in
                
                if error == nil {
                    
                    print("item saved")
                    
                    self.performSegue(withIdentifier: "backToListOfItems", sender: self)
                    
                } else {
                    
                    print(error)
                    
                }
            }
        
        } else {
            
            if modelTextField.text == "" {
            
                modelTextField.layer.borderWidth = 1
                
                modelTextField.layer.borderColor = UIColor.red.cgColor
            
            }
            
            if kindTextField.text == "" {
            
                kindTextField.layer.borderWidth = 1
                
                kindTextField.layer.borderColor = UIColor.red.cgColor
            
            }
            
            if locationTextField.text == "" {
            
                locationTextField.layer.borderWidth = 1
                
                locationTextField.layer.borderColor = UIColor.red.cgColor
            
            }
        
            alertLabel.text = "Model, Kind and Location are required!"
        
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.kindsPicker.delegate   = self
        self.kindsPicker.dataSource = self
        
        self.locationPicker.delegate   = self
        self.locationPicker.dataSource = self
        
        self.sizeColorQuantityPicker.delegate   = self
        self.sizeColorQuantityPicker.dataSource = self
        
        kindsPicker.isHidden             = true
        locationPicker.isHidden          = true
        sizeColorQuantityPicker.isHidden = true
        
        kindsPicker.backgroundColor             = UIColor.black
        locationPicker.backgroundColor          = UIColor.black
        sizeColorQuantityPicker.backgroundColor = UIColor.black
        
        self.modelTextField.delegate    = self
        self.sizeTextField.delegate     = self
        self.colorTextField.delegate    = self
        self.quantityTextField.delegate = self
        self.locationTextField.delegate = self
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        if pickerView.tag == 0 {
            return 1
        } else if pickerView.tag == 1{
            return 3
        } else {
            return 4
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        switch pickerView.tag {
        case 0:
            return kinds.count
        case 1:
            return sizeColorQuantityAr[component].count
        case 2:
            return locationAr[component].count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        switch pickerView.tag {
        case 0:
            return kinds[row]
        case 1:
            return sizeColorQuantityAr[component][row]
        case 2:
            return locationAr[component][row]
        default:
            return "error"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        selectKindButton.isHidden = false
        selectSizeColorQuantityButton.isHidden = false
        
        if pickerView.tag == 0 {
            
            kindSelection = kinds[row]
        
        } else if pickerView.tag == 1 {
            
            switch component {
            case 0:
                sizeColorQuantitySelection[0] = sizeColorQuantityAr[component][row]
            case 1:
                sizeColorQuantitySelection[1] = sizeColorQuantityAr[component][row]
            case 2:
                sizeColorQuantitySelection[2] = String("\(sizeColorQuantityAr[component][row])pcs")
            default:
                return
            }
            
        } else if pickerView.tag == 2 {
            
            locationSelection[component] = locationAr[component][row]
            
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        var titleData = ""
        
        switch pickerView.tag {
        case 0:
            titleData = kinds[row]
        case 1:
            titleData = sizeColorQuantityAr[component][row]
        case 2:
            titleData = locationAr[component][row]
        default:
            titleData = "error"
        }
        
        let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 15.0)!,NSForegroundColorAttributeName:UIColor.white])
        return myTitle
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
