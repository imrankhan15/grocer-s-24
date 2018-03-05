//
//  HomeViewController.swift
//  Everyday's Grocery
//
//  Created by Muhammad Faisal Imran Khan on 1/17/18.
//  Copyright © 2018 MI Apps. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    
    var unitOfMoney: String?
    var password: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
