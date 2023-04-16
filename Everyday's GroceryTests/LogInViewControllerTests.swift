//
//  LogInViewControllerTests.swift
//  Everyday's GroceryTests
//
//  Created by Muhammad Faisal Imran Khan on 15/4/23.
//  Copyright © 2023 MI Apps. All rights reserved.
//

import XCTest
@testable import Everyday_s_Grocery

class LogInViewControllerTests: XCTestCase {

   
    
    func test_viewDidLoad_withoutFilter_defaultValues(){
        let sut = makeSUT()
    }
    private func makeSUT() -> LoginViewController {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let sut = sb.instantiateViewController(identifier: "LoginViewController"){
            coder in LoginViewController(coder: coder)
        }
        return sut
    }
    
    

}
