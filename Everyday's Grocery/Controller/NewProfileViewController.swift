//
//  NewProfileViewController.swift
//  Everyday's Grocery
//
//  Created by Muhammad Faisal Imran Khan on 1/11/18.
//  Copyright © 2018 MI Apps. All rights reserved.
//

import UIKit
import os.log


class NewProfileViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate {

    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var currencyTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    var profiles = [Profile]()
    
    var profile: Profile?
    
    override func viewDidLoad() {
        super.viewDidLoad()

       saveButton.layer.cornerRadius = 5
        
        passwordTextField.delegate = self
        currencyTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.autocorrectionType = .no
        
        currencyTextField.autocorrectionType = .no
        
        emailTextField.autocorrectionType = .no
        
        updateSaveButtonState()
        
        if let savedProfiles = loadProfiles() {
            profiles += savedProfiles
        }

    }

    private func updateSaveButtonState() {
        
        let text = passwordTextField.text ?? ""
        
        let text1 = currencyTextField.text ?? ""
        
        let text2 = emailTextField.text ?? ""
        
        saveButton.isEnabled = !text.isEmpty && !text1.isEmpty && !text2.isEmpty
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func loadProfiles() -> [Profile]?  {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Profile.ArchiveURL.path) as? [Profile]
    }

    func isMatched() -> Bool {
        for profile in profiles {
            
            if profile.password == passwordTextField.text {
                
                return true
            }
        }
        return false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    @IBAction func done_action(_ sender: UIButton) {
        
        if isMatched(){
            let alertTitle = NSLocalizedString("Password Already Exists", comment: "")
            let alertMessage = NSLocalizedString("Please Select Another Password", comment: "")
            
            
            let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.alert) //Replace UIAlertControllerStyle.Alert by UIAlertControllerStyle.alert
            
            
            
            // Replace UIAlertActionStyle.Default by UIAlertActionStyle.default
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                (result : UIAlertAction) -> Void in
                print("OK")
            }
            
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)

            
            
            
        }
        else {
            
            let password = passwordTextField.text
            
            
            
            let currency = currencyTextField.text
            
            let email = emailTextField.text
            
            profile = Profile(password: password!, moneyUnit: currency!, email: email!)
            
            profiles.append(profile!)
            saveProfiles()
            if let owningNavigationController = navigationController{
                owningNavigationController.popViewController(animated: true)
            }
            else {
                fatalError("The LoginViewController is not inside a navigation controller.")
            }           
        }
        
       
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }

    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        saveButton.isEnabled = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        
    }
    
    private func saveProfiles() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(profiles, toFile: Profile.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Items successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save meals...", log: OSLog.default, type: .error)
        }
    }

}
