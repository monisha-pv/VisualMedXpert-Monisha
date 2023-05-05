//
//  RegistrationViewTests.swift
//  VisualMedXpertTests
//
//  Created by Monisha Vadivelu on 01/05/2023.
//

import XCTest
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import Firebase


@testable import VisualMedXpert

class StringExtensionRegistrationTests: XCTestCase {
    
    func testIsValidEmail_ValidEmail() {
        let email = "newuser@example.com"
        XCTAssertTrue(email.isValidEmail)
    }
    
    func testIsValidEmail_InvalidEmail() {
        let email = "newuser@test"
        XCTAssertFalse(email.isValidEmail)
    }
    
    func testIsValidEmail_EmptyString() {
        let email = ""
        XCTAssertFalse(email.isValidEmail)
    }
    
}
