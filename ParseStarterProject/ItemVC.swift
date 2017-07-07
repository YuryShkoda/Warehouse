//
//  ItemVC.swift
//  ParseStarterProject-Swift
//
//  Created by Yuri Shkoda on 6/21/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import CoreData

class ItemVC: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    let warehouse = WarehouseData()
    var pickerAr: [String] = []
    var tag: Int = 0
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var modelTF: UITextField!
    @IBOutlet weak var selectButton: UILabel!
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var addEditButton: UIButton!
    
    @IBAction func addEdit(_ sender: Any) {
        
        if modelTF.text != "" {
            let warehouseItem = WarehouseItem(model: modelTF.text!)
            warehouseItem.addItemToWarehouse()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        picker.isHidden = true
        
        warehouse.getSettingsCD(refresh: nil)
        
        prepareView()
        
        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: scrollView.frame.height + 1)
    }

    func prepareView() {
        
        if warehouse.settingsFields.count > 0 {
            
            var i: Double = 1
            
            for subView in scrollView.subviews {
                if subView.tag != 0 {
                    subView.removeFromSuperview()
                }
            }
            
            for entity in warehouse.settingsFields {
                
                let entityName = entity.key
                let entityDefaults = entity.value
                let textField: UITextField
                let selectLabel: UILabel
                
                if entityDefaults.count > 0 {
                    textField = UITextField(frame: CGRect(x: modelTF.frame.minX, y: modelTF.frame.minY + CGFloat(40 * i), width: modelTF.frame.width - selectButton.frame.width, height: modelTF.frame.height))
                    
                    selectLabel = UILabel(frame: CGRect(x: selectButton.frame.minX, y: selectButton.frame.minY + CGFloat(40 * i), width: selectButton.frame.width, height: selectButton.frame.height))
                    selectLabel.text = "Select"
                    selectLabel.textColor = selectButton.textColor
                    selectLabel.textAlignment = selectButton.textAlignment
                    selectLabel.tag = Int(i)
                    selectLabel.isUserInteractionEnabled = true
                    let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectDefault(tapgestureRecognizer:)))
                    
                    selectLabel.addGestureRecognizer(gestureRecognizer)
                    print(selectLabel)

                    self.scrollView.addSubview(selectLabel)
                    
                } else {
                    textField = UITextField(frame: CGRect(x: modelTF.frame.minX, y: modelTF.frame.minY + CGFloat(40 * i), width: modelTF.frame.width, height: modelTF.frame.height))
                }
                
                textField.borderStyle = UITextBorderStyle.roundedRect
                textField.font = UIFont(name: (textField.font?.fontName)!, size: (textField.font?.pointSize)!)
                textField.placeholder = entityName
                textField.delegate = self
                textField.tag = Int(i)
                print(textField)
                
                self.scrollView.addSubview(textField)
                
                addEditButton.frame = CGRect(x: addEditButton.frame.minX, y: modelTF.frame.minY + CGFloat(40 * i) + 70, width: addEditButton.frame.width, height: addEditButton.frame.height)
                
                i = i + 1
                
                
            }
        }
    }
    
    func selectDefault(tapgestureRecognizer: UITapGestureRecognizer){
        
        hidePicker()
        
        if let tag = tapgestureRecognizer.view?.tag {
            self.tag = tag
            
            if let lb = tapgestureRecognizer.view as? UILabel {
                
                if lb.text == "Done" {
                    
                    lb.text = "Select"
                    var i = 1
                    
                    for entity in warehouse.settingsFields {
                        if i == tag {
                            
                            for subView in view.subviews {
                                
                                if let subView = subView as? UIScrollView {
                                    for subView in subView.subviews {
                                        
                                        if subView.tag == tag {
                                            
                                            if let tf = subView as? UITextField {
                                                
                                                if tf.text == "" {
                                                    tf.text = entity.value[picker.selectedRow(inComponent: 0)]
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            
                            break
                            
                        } else {
                            i = i + 1
                        }
                    }
                } else {
                    var i = 1
                    for entity in warehouse.settingsFields {
                        
                        if i == tag {
                            
                            pickerAr = entity.value
                            
                            for subView in scrollView.subviews {
                                if let lb = subView as? UILabel {
                                    if lb.text == "Done" { lb.text = "Select" }
                                }
                                        
                                if subView.tag == tag {
                                            
                                    if let tf = subView as? UITextField {
                                                
                                        picker.frame = CGRect(x: 0, y: tf.frame.maxY + 10, width: picker.frame.width, height: picker.frame.height)
                                    } else if let lb = subView as?UILabel {
                                        lb.text = "Done"
                                    }
                                            
                                } else if subView.tag > tag {
                                            
                                    subView.frame = CGRect(x: subView.frame.minX, y: subView.frame.minY + picker.frame.height + 10, width: subView.frame.width, height: subView.frame.height)
                                            
                                } else if let btn = subView as? UIButton {
                                    btn.frame = CGRect(x: subView.frame.minX, y: subView.frame.minY + picker.frame.height, width: subView.frame.width, height: subView.frame.height)
                                }
                            }
                            
                            addEditButton.frame = CGRect(x: addEditButton.frame.minX, y: addEditButton.frame.minY + picker.frame.height, width: addEditButton.frame.width, height: addEditButton.frame.height)
                            
                            picker.isHidden = false
                            
                            self.picker.delegate = self
                            self.picker.reloadAllComponents()
                            
                            break
                        } else {
                            i = i + 1
                        }
                    }
                }
            }
        }
    }
    
    func hidePicker(){
    
        if !picker.isHidden {
            
            for subView in view.subviews {
                
                if let subView = subView as? UIScrollView {
                    for subView in subView.subviews {
                        
                        if subView.tag != 0 {
                            
                            subView.frame = CGRect(x: subView.frame.minX, y: modelTF.frame.minY + CGFloat(40 * subView.tag), width: subView.frame.width, height: subView.frame.height)
                            
                            addEditButton.frame = CGRect(x: addEditButton.frame.minX, y: modelTF.frame.minY + CGFloat(40 * subView.tag) + 70, width: addEditButton.frame.width, height: addEditButton.frame.height)
                        }
                    }
                }
            }
            picker.isHidden = true
        }
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
        for subView in view.subviews {
            if let subView = subView as? UIScrollView {
                for subView in subView.subviews {
                    
                    if subView.tag == tag {
                        if let tf = subView as? UITextField {
                            tf.text = pickerAr[row]
                            hidePicker()
                        } else if let lb = subView as? UILabel {
                            if lb.text == "Done" { lb.text = "Select" }
                        }
                    }
                }
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        let myTitle = NSAttributedString(string: pickerAr[row], attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 15.0)!,NSForegroundColorAttributeName:UIColor.white])
        return myTitle
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
