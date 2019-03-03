//
//  GrocerListItemViewController.swift
//  Everyday's Grocery
//
//  Created by Muhammad Faisal Imran Khan on 1/5/18.
//  Copyright © 2018 MI Apps. All rights reserved.
//

import UIKit
import os.log

class GrocerListItemViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var realAmountTextField: UITextField!
    @IBOutlet weak var realPriceTextField: UITextField!
    
    @IBOutlet weak var unitTextField: UITextField!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var moneyTextField: UITextField!
    
     var item: Item?
    
    var unitOfMoney: String?
    var password: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        realAmountTextField.delegate = self
        
        realPriceTextField.delegate = self
        
        unitTextField.delegate = self
        
        moneyTextField.delegate = self
        
        realAmountTextField.autocorrectionType = .no
        realPriceTextField.autocorrectionType = .no
        unitTextField.autocorrectionType = .no
        moneyTextField.autocorrectionType = .no
        
        
        moneyTextField.text = unitOfMoney
        
        if let item = item {
                    navigationItem.title = item.itemName

            
            var realAmountString = ""
            
            var realPriceString = ""
            
            if item.realAmount < 0.1 {
                
                realAmountString = ""
                
            } else {
                
                realAmountString = item.realAmount.description
            }
            
            
            if item.realPrice < 0.1 {
                
                realPriceString = ""
                
            } else {
                
                realPriceString = item.realPrice.description
                
            }
            
            
            realAmountTextField.text = realAmountString
            
            realPriceTextField.text = realPriceString
            
            unitTextField.text = item.unit
           
            
        }
        
         updateSaveButtonState()
        
    }

    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        
      dismiss(animated: true, completion: nil)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    private func updateSaveButtonState() {
        
        let text = realPriceTextField.text ?? ""
        
        let text2 = realAmountTextField.text ?? ""
        
        saveButton.isEnabled = !text.isEmpty && !text2.isEmpty
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
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        let itemName = item?.itemName
        
        let unit = item?.unit
        
        let estimatedAmount = item?.estimatedAmount
        
        
        
        let estimatedPrice = item?.estimatedPrice
        
        let realPrice = Float(realPriceTextField.text!) ?? 0

        
        let realAmount = Float(realAmountTextField.text!) ?? 0
        
        
        item = Item(estimatedPrice: estimatedPrice!, realPrice: Float(realPrice), itemName: itemName!, estimatedAmount: estimatedAmount!, realAmount: Float(realAmount), unit: unit!)
    }
    

 

}
