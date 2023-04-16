//
//  LoginViewController.swift
//  Everyday's Grocery
//
//  Created by Muhammad Faisal Imran Khan on 1/11/18.
//  Copyright © 2018 MI Apps. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    var profiles = [Profile]()
    var unitOfMoney: String?
    var password: String?
    var email: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.layer.cornerRadius = 5
        passwordTextfield.delegate = self
        passwordTextfield.autocorrectionType = .no
        updateLoginButtonState()
        if let savedProfiles = loadProfiles() {
            profiles += savedProfiles
        }
    }

   
    @IBAction func action_logIn(_ sender: UIButton) {
    }
    

}

extension LoginViewController {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        loginButton.isEnabled = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateLoginButtonState()
        
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
   
}

extension LoginViewController {
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func isMatched() -> Bool {
        for profile in profiles {
            if profile.password == passwordTextfield.text {
                unitOfMoney = profile.moneyUnit
                password = profile.password
                email = profile.email
                return true
            }
        }
        return false
    }
    
    
    private func loadProfiles() -> [Profile]?  {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Profile.ArchiveURL.path) as? [Profile]
    }
    
    private func updateLoginButtonState() {
        let passwordText = passwordTextfield.text ?? ""
        loginButton.isEnabled = !passwordText.isEmpty
    }
    
    
    func alertForNoMatch() -> Bool{
        let alertTitle = NSLocalizedString("No Match", comment: "")
        let alertMessage = NSLocalizedString("Please Register", comment: "")
        
        
        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertController.Style.alert)
        
    
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
            (result : UIAlertAction) -> Void in
            print("OK")
        }
        
        
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
        
        
        return false
    }
}
extension LoginViewController {
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "ShowHome" {
            if self.isMatched(){
                return true
            }
            else {
                return alertForNoMatch()
            }
        }
        
        // by default, transition
        return true

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
        case "ShowHome":
            guard let navVc = segue.destination as? UINavigationController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            let homeViewController = navVc.viewControllers.first as! HomeViewController
            homeViewController.unitOfMoney = unitOfMoney
            homeViewController.password = password
            homeViewController.email = email
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
       }
    }

}

