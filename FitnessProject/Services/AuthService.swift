//
//  AuthService.swift
//  FitnessProject
//
//  Created by Wame Gassama on 26/04/2025.
//

import SwiftUI
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

class AuthService: AuthServiceProtocol {
    func signIn(_ email: String,_ password: String) async throws -> UserProtocol {
        let result = try await Auth.auth().signIn(withEmail: email, password: password)
        return result.user
    }
    
    func createNewUser(_ email: String,_ password: String) async throws -> UserProtocol {
        let result = try await Auth.auth().createUser(withEmail: email, password: password)
        return result.user
    }
    
    func signOut() {
        try? Auth.auth().signOut()
    }
    
    func getCurrentUserById() -> String? {
        guard let uid = Auth.auth().currentUser?.uid else { return nil }
        
        return uid
    }
}
