//
//  FirestoreServiceProtocol.swift
//  FitnessProject
//
//  Created by Peter Hannibal Hildorf on 29/04/2025.
//

//
//  FirestoreServiceProtocol.swift
//  FitnessProject
//
//  Created by Wame Gassama on 26/04/2025.
//

//makes sure that the class conform to the protocol 'FirestoreServiceProtocol'
import FirebaseFirestore

protocol FirestoreServiceProtocol {
    func saveUser(user: User) async throws
    func fetchUser(id: String) async -> User?
}
