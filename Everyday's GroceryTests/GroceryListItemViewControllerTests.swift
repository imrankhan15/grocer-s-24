//
//  GroceryListItemViewControllerTests.swift
//  Everyday's GroceryTests
//
//  Created by Muhammad Faisal Imran Khan on 16/4/23.
//  Copyright © 2023 MI Apps. All rights reserved.
//

import XCTest

@testable import Everyday_s_Grocery
class GroceryListItemViewControllerTests: XCTestCase {

    func test_viewDidLoad_withoutFilter_defaultValues(){
        let sut = makeSUT()
        sut.loadViewIfNeeded()
       
    }
    private func makeSUT() -> GrocerListItemViewController {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let sut = sb.instantiateViewController(identifier: "GrocerListItemViewController"){
            coder in GrocerListItemViewController(coder: coder)
        }
        return sut
    }

}
