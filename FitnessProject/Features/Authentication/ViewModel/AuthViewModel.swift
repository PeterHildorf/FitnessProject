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
        let existing = Auth.auth().currentUser
        print("### currentUser ved init:", existing?.uid ?? "nil")
        self.userSession = existing

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
    
    func createNewUser(_ email: String,
                       _ password: String,
                       _ role: String,
                       _ fullname: String
    ) async throws {
        do {
            try validator.validate(email, password)
            let result = try await Auth.auth().createUser(
                withEmail: email,
                password: password
            )
            self.userSession = result.user
            
            let roleEnum = UserRole(rawValue: role.lowercased()) ?? .member

            let user = User(
                id: result.user.uid,
                fullname: fullname,
                email: email,
                role: roleEnum,
                createdEvents: [],
                attendingEvents:  []
            )
            
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
      guard let authUser = Auth.auth().currentUser else { return }

      let snapshot = try? await Firestore.firestore()
        .collection("users")
        .document(authUser.uid)
        .getDocument()

      if let snapshot, snapshot.exists {
        self.currentUser = try? snapshot.data(as: User.self)
      } else {
        // Ingen Firestore-data → tving en logout
        do {
          try Auth.auth().signOut()
        } catch {
          print("Fejl ved signOut:", error)
        }
        self.userSession = nil
        self.currentUser = nil
      }
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
