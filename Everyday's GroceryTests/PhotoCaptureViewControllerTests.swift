//
//  PhotoCaptureViewControllerTests.swift
//  Everyday's GroceryTests
//
//  Created by Muhammad Faisal Imran Khan on 16/4/23.
//  Copyright © 2023 MI Apps. All rights reserved.
//

import XCTest
@testable import Everyday_s_Grocery

class PhotoCaptureViewControllerTests: XCTestCase {

    func test_viewDidLoad_withoutFilter_defaultValues(){
        let sut = makeSUT()
    }
    private func makeSUT() -> PhotoCaptureViewController {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let sut = sb.instantiateViewController(identifier: "PhotoCaptureViewController"){
            coder in PhotoCaptureViewController(coder: coder)
        }
        return sut
    }
    
}
