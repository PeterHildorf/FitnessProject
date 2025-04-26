//
//  MockFirestoreService.swift
//  FitnessProject
//
//  Created by Wame Gassama on 27/04/2025.
//

@testable import FitnessProject

class MockFirestoreService: FirestoreServiceProtocol {
    func saveUser(user: FitnessProject.User) async throws {
        <#code#>
    }
    
    func fetchUser(id: String) async -> FitnessProject.User? {
        <#code#>
    }
    
    
}
