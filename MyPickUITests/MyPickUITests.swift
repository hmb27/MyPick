//
//  MyPickUITests.swift
//  MyPickUITests
//
//  Created by Holly McBride on 03/05/2023.
//

import XCTest

final class MyPickUITests: XCTestCase {

    override func setUpWithError() throws {

        continueAfterFailure = false

        
    }

     /*func testExample() throws {
        let app = XCUIApplication() // app we are testing
        app.launch() // launch
        
        //email field
        let emailField = app.textFields["Email"]
        XCTAssertTrue(emailField.exists)
        
        emailField.tap()
        emailField.typeText("hol@mail.com")
        
        //password field
        let passwordField = app.secureTextFields["Password"]
        XCTAssertTrue(passwordField.exists)
        
        passwordField.tap()
        passwordField.typeText("Curly$.")
        
        //if user has successfully logged in the below Lets go button appears on the home page
        let button = app.buttons["Lets Go"]
        XCTAssertTrue(button.exists)
        
        button.tap()
        let accountLabel = app.staticTexts["Welcome Back Holly"] // label for logged in text
        XCTAssertTrue(accountLabel.exists)
             
    }*/

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
