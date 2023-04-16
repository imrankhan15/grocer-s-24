//
//  HomeViewControllerTests.swift
//  Everyday's GroceryTests
//
//  Created by Muhammad Faisal Imran Khan on 16/4/23.
//  Copyright © 2023 MI Apps. All rights reserved.
//

import XCTest
@testable import Everyday_s_Grocery

class HomeViewControllerTests: XCTestCase {
    func test_viewDidLoad_withoutFilter_defaultValues(){
        let sut = makeSUT()
    }
    private func makeSUT() -> HomeViewController {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let sut = sb.instantiateViewController(identifier: "HomeViewController"){
            coder in HomeViewController(coder: coder)
        }
        return sut
    }
    

}
