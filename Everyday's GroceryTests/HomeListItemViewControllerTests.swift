//
//  HomeListItemViewControllerTests.swift
//  Everyday's GroceryTests
//
//  Created by Muhammad Faisal Imran Khan on 16/4/23.
//  Copyright © 2023 MI Apps. All rights reserved.
//

import XCTest
@testable import Everyday_s_Grocery

class HomeListItemViewControllerTests: XCTestCase {

    func test_viewDidLoad_withoutFilter_defaultValues(){
        let sut = makeSUT()
    }
    private func makeSUT() -> HomeListItemViewController {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let sut = sb.instantiateViewController(identifier: "HomeListItemViewController"){
            coder in HomeListItemViewController(coder: coder)
        }
        return sut
    }
    

}
