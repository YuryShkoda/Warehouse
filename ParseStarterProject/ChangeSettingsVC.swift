//
//  ChangeSettingsVC.swift
//  ParseStarterProject-Swift
//
//  Created by Yuri Shkoda on 6/10/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit

class ChangeSettingsVC: UIViewController {
    
    var settingToChange: [Int] = []
    
    var placeHolders: [String] = []
    
    var changeName: Bool = false
    var isFirstFieldAnabled: Bool = true
    var newName: String = ""
    
    var createNewField: Bool = false
    var newField: String = ""
    
    var isSecureEntry = false
    var curPass = ""
    var newPass = ""

    @IBOutlet weak var textField: UITextField!
    @IBAction func saveButtonClicked(_ sender: Any) {
        
        var readyForSegue = true
        
        curPass = ""
        newPass = ""
        
        var i = 0
            
        for subView in self.view.subviews as [UIView] {
            
            if let tf = subView as? UITextField {
                    
                if tf.isEnabled && tf.text == "" {
                    
                    tf.layer.borderWidth = 1
                    tf.layer.borderColor = UIColor.red.cgColor
                    readyForSegue = false
                    
                } else if tf.isSecureTextEntry {
                    
                    if newPass != tf.text && newPass != "" && i > 0 {
                    
                        tf.layer.borderWidth = 1
                        tf.layer.borderColor = UIColor.red.cgColor
                        readyForSegue = false
                    
                    } else {
                    
                        if i == 0 { curPass = tf.text! } else { newPass = tf.text! }
                    }
                    
                } else {
                    
                    if createNewField {
                        newField = tf.text!
                    } else if changeName {
                        newName = tf.text!
                    }
                }
                
                i = i + 1
            }
        }
        
        if readyForSegue { performSegue(withIdentifier: "toSettingsSegue", sender: nil) }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toSettingsSegue" {
        
            if let settingsVC = segue.destination as? SettingsVC {
                
                if createNewField {
                    settingsVC.newField = self.newField
                } else if changeName {
                    settingsVC.newName = self.newName
                } else if isSecureEntry {
                    settingsVC.curPass = self.curPass
                    settingsVC.newPass = self.newPass
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareTextFields()
    }
    
    func prepareTextFields(){
        
        for i in 0..<placeHolders.count {
            
            if i >= 1 {
                
                let tf = UITextField(frame: CGRect(x: textField.frame.minX, y: textField.frame.minY + CGFloat(50 * i), width: textField.frame.width, height: textField.frame.height))
                tf.borderStyle = UITextBorderStyle.roundedRect
                tf.font = UIFont(name: (textField.font?.fontName)!, size: (textField.font?.pointSize)!)
                tf.placeholder = placeHolders[i]
                tf.isSecureTextEntry = self.isSecureEntry
                self.view.addSubview(tf)
                
            } else {
            
                textField.placeholder = placeHolders[i]
                textField.isSecureTextEntry = self.isSecureEntry
                textField.isEnabled = isFirstFieldAnabled
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
