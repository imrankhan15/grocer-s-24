//
//  LogOutViewController.swift
//  Everyday's Grocery
//
//  Created by Muhammad Faisal Imran Khan on 1/17/18.
//  Copyright © 2018 MI Apps. All rights reserved.
//

import UIKit


class LogOutViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var registerButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

      
        loginButton.layer.cornerRadius = 5
        
        registerButton.layer.cornerRadius = 5
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func unwindToLoginView(segue: UIStoryboardSegue) {
        
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
