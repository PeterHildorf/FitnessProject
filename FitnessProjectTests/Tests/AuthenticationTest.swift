//
//  AuthenticationTest.swift
//  FitnessProjectTests
//
//  Created by Wame Gassama on 26/04/2025.
//

import XCTest
@testable import FitnessProject

@MainActor
final class AuthenticationTest: XCTestCase {
    private var viewModel: AuthViewModel!
    private var mockAuthService: MockAuthService = MockAuthService()
    private var mockFirestoreService: MockFirestoreService  = MockFirestoreService()

    override func setUp() {
        super.setUp()
        viewModel = AuthViewModel(authService: mockAuthService, firestoreService: mockFirestoreService)
    }
    
    override func tearDown() {
        viewModel = nil
        mockAuthService = MockAuthService()
        mockFirestoreService = MockFirestoreService()
        super.tearDown()
    }
    
    func testSignInSuccess() async {
        let email = "mock@gmail.com"
        let password = "mock123"
        let user = "mock_uid"
        
        try? await viewModel.signIn(email, password)
        
        
        XCTAssertEqual(viewModel.userSession?.uid, user)
        XCTAssertEqual(viewModel.currentUser?.id, user)
    }
    
    func testSignInFailure() async {
        let email = "wrong_mock@gmail.com"
        let password = "wrong_mock123"
        
        try? await viewModel.signIn(email, password)
        
        
        XCTAssertTrue(viewModel.hasError)
        XCTAssertEqual(viewModel.error?.errorDescription, "Unable to Sign In")
        XCTAssertEqual(viewModel.error?.failureReason, "Incorrect email or password. Please try again.")
    }
    
    func testSignUpSuccess() async {
        let email = "newMock@gmail.com"
        let password = "newMock123"
        let role = "Instructor"
        let fullname = "New Mock"
        
        mockAuthService.currentUser = "new_mock_uid"
        
        try? await viewModel.createNewUser(email, password, role, fullname)
        
        
        XCTAssertEqual(viewModel.userSession?.uid, "new_mock_uid")
        XCTAssertEqual(viewModel.currentUser?.email, email)
        XCTAssertEqual(viewModel.currentUser?.role, role)
        XCTAssertEqual(viewModel.currentUser?.fullname, fullname)
    }
    
    func testSignUpFailure() async {
        let email = "newMock@gmail.com"
        let password = "newMock123"
        let role = "Instructor"
        let fullname = "New Mock"
        
        mockAuthService.serverFailure = true
        
        try? await viewModel.createNewUser(email, password, role, fullname)
        
        
        XCTAssertTrue(viewModel.hasError)
        XCTAssertEqual(viewModel.error?.errorDescription, "Something went wrong!")
        XCTAssertEqual(viewModel.error?.failureReason, "The operation couldn’t be completed. Server failure")
    }
    
    func testSignOut() {
        viewModel.signOut()
        
        XCTAssertTrue(mockAuthService.signedOut)
        XCTAssertNil(viewModel.userSession)
        XCTAssertNil(viewModel.currentUser)
    }
    
    func testEmptyEmail() async {
        let email = ""
        let password = "newMock123"
        
        await assertEqualValidationError(email, password, "Invalid Email", "Email address is required")
    }
    
    func testInvalidEmail() async {
        let email = "Mock@@gmail.com"
        let password = "newMock123"
        
        await assertEqualValidationError(email, password, "Invalid Email", "Please type a valid email address")
    }
    
    func testEmptyPassword() async {
        let email = "Mock@gmail.com"
        let password = ""
        
        await assertEqualValidationError(email, password, "Invalid Password", "Password is required")
    }
    
    func testInvalidPassword() async {
        let email = "Mock@gmail.com"
        let password = "mock"
        
        await assertEqualValidationError(email, password, "Invalid Password", "Password must be at least 6 characters long")
    }
    
    func assertEqualValidationError(_ email: String,_ password: String,_ expectedErrorDescription: String,_ expectedFailureReason: String) async {
        
        try? await viewModel.createNewUser(email, password, "Instructor", "Mock")
        
        XCTAssertEqual(viewModel.error?.errorDescription, expectedErrorDescription)
        XCTAssertEqual(viewModel.error?.failureReason, expectedFailureReason)
    }
}
