//
//  MockAuthService.swift
//  FitnessProject
//
//  Created by Wame Gassama on 26/04/2025.
//

@testable import FitnessProject
@testable import FirebaseAuth

class MockAuthService: AuthServiceProtocol {
    private var serverFailure = false
    private var currentUser = true
    private var signedOut = false
    
    func simulateServerFailure() {
        serverFailure = true
    }
    
    func simulateServerSucess() {
        serverFailure = true
    }
    
    func simulateNoCurrentUser() {
        currentUser = false
    }
    
    func simulateSignedOut() {
        signedOut = true
    }
    
    func signIn(_ email: String, _ password: String) async throws -> UserProtocol {
        //simulate authentication failure
        if email != "mock@gmail.com" && password != "mock123" {
            throw NSError()
        } else {
            return MockFirebaseUser("mock_uid")
        }
    }
    
    func createNewUser(_ email: String, _ password: String) async throws -> UserProtocol {
        
        if serverFailure {
            throw NSError(domain: "", code: 500, userInfo: [NSLocalizedFailureReasonErrorKey: "Server failure"])
        } else {
            
            return MockFirebaseUser("mock_uid")
        }
    }
    
    func signOut() {
        print("Signed out")
    }
    
    func getCurrentUserById() -> String? {
        if currentUser {
            return "mock_uid"
        } else {
            return nil
        }
    }
}
