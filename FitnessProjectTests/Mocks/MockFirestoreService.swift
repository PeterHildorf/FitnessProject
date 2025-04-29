//
//  Untitled.swift
//  FitnessProject
//
//  Created by Peter Hannibal Hildorf on 29/04/2025.
//

//
//  MockFirestoreService.swift
//  FitnessProject
//
//  Created by Wame Gassama on 27/04/2025.
//
@testable import FitnessProject

class MockFirestoreService: FirestoreServiceProtocol {
    private var mockDatabase: [User] = [
            User(
                id: "mock_uid",
                fullname: "Mock",
                email: "mock@gmail.com",
                role: .member,          // enum-værdi direkte
                createdEvents: [],      // ← tilføj
                attendingEvents: []     // ← tilføj
            )
        ]
    
    func saveUser(user: FitnessProject.User) async throws {
        mockDatabase.append(user)
    }
    
    func fetchUser(id: String) async -> User? {
        return mockDatabase.first(where: { $0.id == id })
    }
}
