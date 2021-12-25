//
//  HomeViewController.swift
//  Everyday's Grocery
//
//  Created by Muhammad Faisal Imran Khan on 1/17/18.
//  Copyright © 2018 MI Apps. All rights reserved.
//

import UIKit


class HomeViewController: UIViewController {

    @IBOutlet weak var btnOne: UIButton!
    @IBOutlet weak var btnTwo: UIButton!
    @IBOutlet weak var btnThree: UIButton!
    var unitOfMoney: String?
    var password: String?
    var email: String?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        btnOne.layer.cornerRadius = 5
        btnTwo.layer.cornerRadius = 5
        btnThree.layer.cornerRadius = 5
     }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToHomeView(segue: UIStoryboardSegue) {
        //nothing goes here
    }
    
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
