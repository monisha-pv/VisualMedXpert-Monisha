//
//  LoginViewTests.swift
//  VisualMedXpertTests
//
//  Created by Monisha Vadivelu on 30/04/2023.
//

import XCTest
@testable import VisualMedXpert

class StringExtensionDoctorLoginTests: XCTestCase {
    
    func testIsValidEmailLogin_ValidEmail() {
        let email = "newuser@example.com"
        XCTAssertTrue(email.isValidEmailLogin, "Valid email should pass isValidEmailLogin test")
    }
    
    func testIsValidEmailLogin_InvalidEmail() {
        let email = "newuser@test"
        XCTAssertFalse(email.isValidEmailLogin, "Invalid email should fail isValidEmailLogin test")
    }
    
    func testIsValidEmailLogin_EmptyString() {
        let email = ""
        XCTAssertFalse(email.isValidEmailLogin, "Empty string should fail isValidEmailLogin test")
    }
}
