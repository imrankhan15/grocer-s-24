//
//  HomeListTableViewControllerTests.swift
//  Everyday's GroceryTests
//
//  Created by Muhammad Faisal Imran Khan on 16/4/23.
//  Copyright © 2023 MI Apps. All rights reserved.
//

import XCTest

@testable import Everyday_s_Grocery
class HomeListTableViewControllerTests: XCTestCase {
    func test_viewDidLoad_withoutFilter_defaultValues(){
        let sut = makeSUT()
        
        sut.loadViewIfNeeded()
        XCTAssertEqual(sut.tableView.numberOfRows(inSection: 0), 0)
    }
    private func makeSUT() -> HomeListTableViewController {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let sut = sb.instantiateViewController(identifier: "HomeListTableViewController"){
            coder in HomeListTableViewController(coder: coder)
        }
        return sut
    }
    

}
