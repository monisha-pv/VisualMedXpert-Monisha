//
//  VisualMedXpertUITests.swift
//  VisualMedXpertUITests
//
//  Created by Monisha Vadivelu on 12/11/2022.
//

import XCTest

class VisualMedXpertUITests: XCTestCase {
    
    override func setUpWithError() throws {
        continueAfterFailure = false
    }
    
    override func tearDownWithError() throws {
    }
    
    func test_RegistrationView_Init() throws {
        let app = XCUIApplication()
        app.launch()
        
        XCTAssertTrue(app.staticTexts["Register"].exists)
    }
    
    func test_RegistrationView_EnableButton() throws {
        let app = XCUIApplication()
        app.launch()
        
        let emailTextField = app.textFields["Email"]
        emailTextField.tap()
        emailTextField.typeText("newuser@example.com")
        
        let passwordTextField = app.secureTextFields["Password"]
        passwordTextField.tap()
        passwordTextField.typeText("password123")
        
        let signUpButton = app.buttons["Sign Up"]
        let isEnabled = signUpButton.isEnabled
        
        sleep(1)
        emailTextField.typeText("a")
        
        XCTAssertTrue(!isEnabled && signUpButton.isEnabled)
    }
    
    func test_RegistrationView_ValidRegistration() throws {
        let app = XCUIApplication()
        app.launch()
        
        let emailTextField = app.textFields["Email"]
        emailTextField.tap()
        emailTextField.typeText("newuser@example.com")
        
        let passwordTextField = app.secureTextFields["Password"]
        passwordTextField.tap()
        passwordTextField.typeText("password123")
        
        let signUpButton = app.buttons["Sign Up"]
        XCTAssertTrue(signUpButton.isEnabled)
        signUpButton.tap()
        
        let successAlert = app.alerts["Success"]
        XCTAssertTrue(successAlert.waitForExistence(timeout: 10))
        XCTAssertEqual(successAlert.staticTexts.firstMatch.label, "You have successfully registered to VMX.")
    }
}



