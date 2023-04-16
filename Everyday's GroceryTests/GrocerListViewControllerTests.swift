//
//  GrocerListViewControllerTests.swift
//  Everyday's GroceryTests
//
//  Created by Muhammad Faisal Imran Khan on 16/4/23.
//  Copyright © 2023 MI Apps. All rights reserved.
//

import XCTest

@testable import Everyday_s_Grocery
class GrocerListViewControllerTests: XCTestCase {
    func test_viewDidLoad_withoutFilter_defaultValues(){
        let sut = makeSUT()
        sut.loadViewIfNeeded()
        XCTAssertEqual(sut.tableView.numberOfRows(inSection: 0), 0)
    }
    private func makeSUT() -> GrocerListViewController {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let sut = sb.instantiateViewController(identifier: "GrocerListViewController"){
            coder in GrocerListViewController(coder: coder)
        }
        return sut
    }
   
}
