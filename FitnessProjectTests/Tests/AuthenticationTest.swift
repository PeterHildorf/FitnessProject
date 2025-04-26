//
//  AuthenticationTest.swift
//  FitnessProjectTests
//
//  Created by Wame Gassama on 26/04/2025.
//

import XCTest
@testable import FitnessProject

final class AuthenticationTest: XCTestCase {
    override func setUp() {
        <#code#>
    }
    
    override func tearDown() {
        <#code#>
    }
    
    func testEmptyEmail() {
        let email = ""
        let password = "test123"
        let validator = CreateValidator()
        
        do {
            try validator.validate(email, password)
        } catch {
            let error = error as! CreateValidator.CreateValidatorError
            
            XCTAssertEqual(error.failureReason, "Email address is required")
        }
    }
    
    func testInvalidEmail() {
        let email = "Blah.blach123"
        let password = "test123"
        let validator = CreateValidator()
        
        do {
            try validator.validate(email, password)
        } catch {
            let error = error as! CreateValidator.CreateValidatorError
            
            XCTAssertEqual(error.failureReason, "Please type a valid email address")
        }
    }
    
    func testEmptyPassword() {
        let email = "test@gmail.com"
        let password = ""
        let validator = CreateValidator()
        
        do {
            try validator.validate(email, password)
        } catch {
            let error = error as! CreateValidator.CreateValidatorError
            
            XCTAssertEqual(error.failureReason, "Password is required")
        }
    }
    
    func testInvalidPassword() {
        let email = "test@gmail.com"
        let password = "test12"
        let validator = CreateValidator()
        
        do {
            try validator.validate(email, password)
        } catch {
            let error = error as! CreateValidator.CreateValidatorError
            
            XCTAssertEqual(error.failureReason, "Password must be at least 6 characters long")
        }
    }
    
    
}
