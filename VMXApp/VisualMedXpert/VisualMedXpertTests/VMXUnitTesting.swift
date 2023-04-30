//
//  VMXUnitTesting.swift
//  VisualMedXpertUITests
//
//  Created by Monisha Vadivelu on 30/04/2023.
//

import XCTest
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import Firebase


@testable import VisualMedXpert

class StringExtensionTests: XCTestCase {
    
    func testIsValidEmail_ValidEmail() {
        let email = "user@example.com"
        XCTAssertTrue(email.isValidEmail)
    }
    
    func testIsValidEmail_InvalidEmail() {
        let email = "user@example"
        XCTAssertFalse(email.isValidEmail)
    }
    
    func testIsValidEmail_EmptyString() {
        let email = ""
        XCTAssertFalse(email.isValidEmail)
    }
    
}

