//
//  HomeListItemViewController.swift
//  Everyday's Grocery
//
//  Created by Muhammad Faisal Imran Khan on 12/29/17.
//  Copyright © 2017 MI Apps. All rights reserved.
//

import UIKit
import os.log
import GoogleMobileAds

class HomeListItemViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, PhotoCaptureViewControllerDelegate {
     func PhotoCaptureViewControllerResponse(url: String) {
        savedimageUrl = url
    }
    

    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var itemNameTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var estimatedAmountTextField: UITextField!
    @IBOutlet weak var estimatedPriceTestField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var unitTextField: UITextField!
    
    @IBOutlet weak var moneyTextField: UITextField!
    
    var item: Item?
    
    var unitOfMoney: String?
    
    var password: String?
    
    var savedimageUrl = String()
    
    override func viewWillAppear(_ animated: Bool) {
        if !savedimageUrl.isEmpty {
            let image = getImageFromPath(sender: savedimageUrl) as UIImage
            
            imageView.image = image
        }
        updateSaveButtonState()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bannerView.adUnitID = "ca-app-pub-4598488303993049/8903355673"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
        
        itemNameTextField.delegate = self
        estimatedPriceTestField.delegate = self
        estimatedAmountTextField.delegate = self
        unitTextField.delegate = self
        moneyTextField.delegate = self
        
        itemNameTextField.autocorrectionType = .no
        estimatedPriceTestField.autocorrectionType = .no
        estimatedAmountTextField.autocorrectionType = .no
        unitTextField.autocorrectionType = .no
        moneyTextField.autocorrectionType = .no
        
        moneyTextField.text = unitOfMoney
        self.automaticallyAdjustsScrollViewInsets = false
        // Set up views if editing an existing Item.
        
        if !savedimageUrl.isEmpty {
            let image = getImageFromPath(sender: savedimageUrl) as UIImage
            
            imageView.image = image
        }
        if let item = item {
            navigationItem.title = item.itemName
            itemNameTextField.text = item.itemName
            estimatedPriceTestField.text = item.estimatedPrice.description
            estimatedAmountTextField.text = item.estimatedAmount.description
            unitTextField.text = item.unit
            if !item.imageURL.isEmpty {
                let image = getImageFromPath(sender: item.imageURL) as UIImage
                
                imageView.image = image
            }
            
        }
        
        
        updateSaveButtonState()
    }

    func getImageFromPath(sender: String) -> UIImage {
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask    = FileManager.SearchPathDomainMask.userDomainMask
        let paths               = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        
        var image = UIImage()
        if let dirPath          = paths.first
        {
            let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent(sender)
            image    = UIImage(contentsOfFile: imageURL.path)!
            
            return image
            // Do whatever you want with the image
        }
        
        return image
    }
    
    
    func isModal() -> Bool {
        if self.presentingViewController != nil {
            return true
        }
        
        return false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    private var wasPushed: Bool {
        guard let vc = navigationController?.viewControllers.first, vc == self else {
            return true
        }
        
        return false
    }
   
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        
        
        let isPresentingInAddltemMode = wasPushed
        
        
       
        
        if !isPresentingInAddltemMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The ItemViewController is not inside a navigation controller.")
        }
    }
    
   
    
    
    
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func updateSaveButtonState() {
        
        let text = itemNameTextField.text ?? ""
        
        let text2 = estimatedPriceTestField.text ?? ""
        
        let text3 = estimatedAmountTextField.text ?? ""
        
        let text4 = unitTextField.text ?? ""
        
        let text5 = moneyTextField.text ?? ""
        
        saveButton.isEnabled = !text.isEmpty && !text2.isEmpty && !text3.isEmpty && !text4.isEmpty && !text5.isEmpty && !savedimageUrl.isEmpty
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
    // MARK: - Navigation

  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)

        switch(segue.identifier ?? "") {
            
        case "photo":
        guard let photoCaptureViewController = segue.destination as? PhotoCaptureViewController else {
            fatalError("Unexpected destination: \(segue.destination)")
        }
        
       photoCaptureViewController.delegate = self
        
        
        default:
     
    
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        let itemName = itemNameTextField.text ?? ""
        
       let unit = unitTextField.text ?? ""
        
        let estimatedAmount = Float(estimatedAmountTextField.text!) ?? 0
        
      

        let estimatedPrice = Float(estimatedPriceTestField.text!) ?? 0
        
        
        
        let realPrice = 0.0
        
        let realAmount = 0.0
      
        
        item = Item(estimatedPrice: estimatedPrice, realPrice: Float(realPrice), itemName: itemName, estimatedAmount: estimatedAmount, realAmount: Float(realAmount), unit: unit, imageURL: savedimageUrl)
    }
 
}

}
