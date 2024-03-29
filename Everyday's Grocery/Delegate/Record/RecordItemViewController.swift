//
//  RecordItemViewController.swift
//  Everyday's Grocery
//
//  Created by Muhammad Faisal Imran Khan on 1/10/18.
//  Copyright © 2018 MI Apps. All rights reserved.
//

import UIKit

import MessageUI

class RecordItemViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate {
    
    var items = [Item]()
    var dateTime:String = ""
    var unitOfMoney: String?
    var password: String?
    var email: String?
    
    @IBOutlet weak var label_total: UILabel!
    @IBOutlet var tableView: UITableView!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let backgroundImage = UIImage(named: "images_1_.png")
        let imageView = UIImageView(image: backgroundImage)
        self.tableView.backgroundView = imageView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        update_label_total()
    }
}

extension RecordItemViewController{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "RecordItemTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? RecordItemTableViewCell  else {
            fatalError("The dequeued cell is not an instance of RecordTableViewCell.")
        }
        cell.layer.backgroundColor = UIColor.clear.cgColor
        let item = items[indexPath.row]
        cell.itemDetails.text = realPriceString(item: item)
        if !item.imageURL.isEmpty {
            if item.imageURL.range(of:"noImage") == nil {
                let image = getImageFromPath(sender: item.imageURL) as UIImage
                cell.recordItemImage.image = image
            }
         }
        return cell
    }
}

extension RecordItemViewController{
    func calculateMessage(item: Item) -> String {
        let estimatedPrice = item.estimatedPrice
        let realPrice = item.realPrice as! Float
        let itemName = item.itemName as! String
        let estimatedAmount = item.estimatedAmount as! Float
        let realAmount = item.realAmount as! Float
        let unit = item.unit as! String
        
       let msg = "estimatedPrice: " + estimatedPrice.description + " realPrice: " + realPrice.description + " itemName: " + itemName + " estimatedAmount: " + estimatedAmount.description
            + " realAmount: " + realAmount.description + " unit: " + unit
        
        return msg
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
   
    func update_label_total() {
        
        var total = Float(0.0)
        
        for Item in items{
            total += Float(Item.realAmount) * Float(Item.realPrice)
        }
        let alertTitle = NSLocalizedString("Total Spent :", comment: "")
        label_total.text = alertTitle  + total.description + " " + unitOfMoney! + " "
    }
    
    func realPriceString(item: Item) -> String {
        var realAmountString = ""
        var realPriceString = ""
        realAmountString = item.realAmount.description + " " + item.unit
        
        realPriceString = item.realPrice.description + " " + unitOfMoney! + " "
        let itemName = NSLocalizedString(" Item Name: ", comment: "")
        let boughtAmount = NSLocalizedString(", Bought Amount: " , comment: "")
        let boughtPreis = NSLocalizedString(", Bought Price: ", comment: "")
        
        let return_string = itemName + item.itemName
            + boughtAmount + realAmountString + " " + boughtPreis + realPriceString
        
        return return_string
        
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
         }
        return image
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}
extension RecordItemViewController{
    @objc func mailReport(){
        let mailComposeViewController = configureMailController()
        if MFMailComposeViewController.canSendMail(){
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            showMailError()
        }
    }
    
    
    func configureMailController() -> MFMailComposeViewController{
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients([email!])
        mailComposerVC.setSubject("Your grocery list")
        var message = "<!DOCTYPE html><html><body> <p>This is your grocery list.</p>"
        
        
        var image_name = 1
        for item in items {
            
            let imageURL = item.imageURL as! String
            
            if !imageURL.isEmpty {
                
                if imageURL.range(of:"noImage") == nil {
                    var image = getImageFromPath(sender: imageURL)
                    
                    var newSize: CGSize
                    
                    newSize = CGSize(width: 200.0, height: 200.0)
                    image = self.resizeImage(image:image, targetSize: newSize)
                    let imageData = image.jpegData(compressionQuality: 1)
                    
                    mailComposerVC.addAttachmentData(imageData!, mimeType: "image/jpeg", fileName: String(image_name))
                    
                    image_name = image_name + 1
                }
            }
            message += "<p>" + calculateMessage(item: item) + "</p>"
        }
        message += "</body></html>"
        mailComposerVC.setMessageBody(message, isHTML: true)
        return mailComposerVC
    }
    
    func showMailError(){
        let alertTitle = NSLocalizedString("Could not send email", comment: "")
        let alertDescription = NSLocalizedString("Your device cannot send email", comment: "")
        let sendMailErrorAlert = UIAlertController(title: alertTitle, message: alertDescription, preferredStyle: .alert)
        let dismiss = UIAlertAction(title: "Ok", style: .default, handler: nil)
        sendMailErrorAlert.addAction(dismiss)
        self.present(sendMailErrorAlert, animated: true, completion: nil)
    }
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }

}
