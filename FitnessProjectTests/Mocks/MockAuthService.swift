//
//  MockAuthService.swift
//  FitnessProject
//
//  Created by Wame Gassama on 26/04/2025.
//

@testable import FitnessProject
@testable import FirebaseAuth

class MockAuthService: AuthServiceProtocol {
    var serverFailure = false
    var currentUser: String? = nil
    var signedOut = false
    
    func signIn(_ email: String, _ password: String) async throws -> UserProtocol {
        //simulates authentication failure
        if email == "mock@gmail.com" && password == "mock123" {
            return MockFirebaseUser("mock_uid")
        } else {
            //Simulates an error, the error gets handle in the viewModel
            throw NSError(domain: "AuthError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid credentials"])        }
    }
    
    func createNewUser(_ email: String, _ password: String) async throws -> UserProtocol {
        
        if serverFailure {
            throw NSError(domain: "", code: 500, userInfo: [NSLocalizedFailureReasonErrorKey: "Server failure"])
        } else {
            
            return MockFirebaseUser("new_mock_uid")
        }
    }
    
    func signOut() {
        signedOut = true
    }
    
    func getCurrentUserById() -> String? {
        return currentUser
    }
}
