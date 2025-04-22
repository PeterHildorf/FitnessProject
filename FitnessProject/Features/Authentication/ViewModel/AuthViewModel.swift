//
//  LoginViewModel.swift
//  FitnessProject
//
//  Created by Wame Gassama on 01/04/2025.
//

import SwiftUI
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

@MainActor
class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    @Published var seletedType: String = "Member"
    @Published var error: Validation?
    @Published var hasError: Bool = false
    
    init() {
        //Checks if there is a current user logged in, when the view model initializes.
        self.userSession = Auth.auth().currentUser
        
        Task {
            await fetchUser()
        }
    }
    
    private let validator = CreateValidator()
    
    func signIn(_ email: String,_ password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            await fetchUser()
        } catch {
            self.error = .custom(.authFailed)
            self.hasError = true
        }
    }
    
    func createNewUser(_ email: String,_ password: String,_ role: String,_ fullname: String) async throws {
        do {
            try validator.validate(email, password)
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            let user = User(id: result.user.uid, fullname: fullname, email: email, role: role)
            let encodedUser = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
            await fetchUser()
        } catch let error as CreateValidator.CreateValidatorError {
            self.error = .custom(error)
            self.hasError = true
        } catch {
            self.error = .firebase("An unexpected error occurred: \(error.localizedDescription)")
            self.hasError = true
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.userSession = nil
            self.currentUser = nil
        } catch {
            print("Failed to sign out")
        }
    }
    
    func fetchUser() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        guard let userDocument = try? await Firestore.firestore().collection("users").document(uid).getDocument() else { return }
        
        //Decodes the data from firebase into the user model.
        self.currentUser = try? userDocument.data(as: User.self)
    }
    
    enum Validation: LocalizedError {
        case custom(CreateValidator.CreateValidatorError)
        case firebase(String)
        case firestore(String)
        
        var errorDescription: String? {
            switch self {
            case .custom(let error):
                return error.localizedDescription
            case .firebase(let message), .firestore(let message):
                return message
            }
        }
        
        var failureReason: String? {
            switch self {
            case .custom(let error):
                return error.failureReason
            case .firebase(let message), .firestore(let message):
                return message
            }
        }
    }
}
