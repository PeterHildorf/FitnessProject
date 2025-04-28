//
//  FirestoreService.swift
//  FitnessProject
//
//  Created by Wame Gassama on 26/04/2025.
//

import SwiftUI
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

class FirestoreService {
    func saveUser(user: User) async throws  {
        let encodedUser = try Firestore.Encoder().encode(user)
        try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
    }
    
    func fetchUser(id: String) async -> User? {
        guard let userDocument = try? await Firestore.firestore().collection("users").document(id).getDocument() else { return nil }
        
        //Decodes the data from firebase into the user model.
        let decodedUser = try? userDocument.data(as: User.self)
        
        return decodedUser
    }
}
