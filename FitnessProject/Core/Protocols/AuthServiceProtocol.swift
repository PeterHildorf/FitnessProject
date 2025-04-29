//
//  AuthServiceProtocol.swift
//  FitnessProject
//
//  Created by Peter Hannibal Hildorf on 29/04/2025.
//

import FirebaseAuth

//makes sure that the class conform to the protocol 'AuthServiceProtocol'

protocol AuthServiceProtocol {
    func signIn(_ email: String,_ password: String) async throws -> UserProtocol
    func createNewUser(_ email: String,_ password: String) async throws -> UserProtocol
    func signOut()
    func getCurrentUserById() -> String?
    
}
