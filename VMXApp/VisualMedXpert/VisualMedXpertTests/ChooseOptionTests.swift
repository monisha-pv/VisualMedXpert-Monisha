//
//  ChooseOptionTests.swift
//  VisualMedXpertTests
//
//  Created by Monisha Vadivelu on 30/04/2023.
//

import XCTest
import Firebase
@testable import VisualMedXpert

class ChooseOptionViewTests: XCTestCase {

    func testLogout() throws {
        let view = ChooseOptionView()
        let expectation = XCTestExpectation(description: "Sign out should be called")
        
        view.dismiss = {
            expectation.fulfill()
        }
        
        view.logout()
        
        wait(for: [expectation], timeout: 5.0)
    }
    
}

