//
//  HomeViewController.swift
//  Everyday's Grocery
//
//  Created by Muhammad Faisal Imran Khan on 1/17/18.
//  Copyright © 2018 MI Apps. All rights reserved.
//

import UIKit
import GoogleMobileAds

class HomeViewController: UIViewController {

    
    var unitOfMoney: String?
    var password: String?
    var email: String?
    @IBOutlet weak var bannerView: GADBannerView!
    override func viewDidLoad() {
        super.viewDidLoad()

        bannerView.adUnitID = "ca-app-pub-4598488303993049/8903355673"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToHomeView(segue: UIStoryboardSegue) {
        //nothing goes here
    }
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
        case "ShowOld":
            
          
            
            guard let recordViewController = segue.destination as? RecordViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            

            
            recordViewController.unitOfMoney = unitOfMoney
            recordViewController.password = password
            recordViewController.email = email
            
        case "MakeNew":
            
         
            guard let navVc = segue.destination as? UINavigationController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            let homeListTableViewController = navVc.viewControllers.first as! HomeListTableViewController
            
           
            

            
            homeListTableViewController.unitOfMoney = unitOfMoney
            homeListTableViewController.password = password
            
        default: break
           
            
        }
    }


}
