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
    @Published var userSession: UserProtocol?
    @Published var currentUser: User?
    @Published var seletedType: String = "Member"
    @Published var currentRole: UserRole = .member
    @Published var error: Validation?
    @Published var hasError: Bool = false
    
    private let authService: AuthServiceProtocol
    private let firestoreService: FirestoreServiceProtocol
    private let validator = CreateValidator()
    
    // setting role to define the rules so the user have different options that depens on role
    private func setRole(from user: User?) {
        currentRole = user?.role ?? .member
    }
    
    init(authService: AuthServiceProtocol = AuthService(), firestoreService: FirestoreServiceProtocol = FirestoreService()) {
        //Injecting the Firebase services into the view model
        self.authService = authService
        self.firestoreService = firestoreService
        
        //Checks if there is a current user logged in, when the view model initializes.
        self.userSession = Auth.auth().currentUser
        
        Task {
            await fetchUser()
        }
    }
    
    func signIn(_ email: String,_ password: String) async throws {
        do {
            let result = try await authService.signIn(email, password)
            self.userSession = result
            self.currentUser = await firestoreService.fetchUser(id: result.uid)
            self.currentRole = self.currentUser?.role ?? .member
        } catch {
            self.error = .custom(.authFailed)
            self.hasError = true
        }
    }
    
    func createNewUser(_ email: String,_ password: String,_ role: String,_ fullname: String) async throws {
        do {
            try validator.validate(email, password)
            let result = try await authService.createNewUser(email, password)
            self.userSession = result
            let roleEnum = UserRole(rawValue: role.lowercased()) ?? .member
            let user = User(id: result.uid, fullname: fullname, email: email, role: roleEnum, createdEvents: [], attendingEvents:  [])
            
            try await firestoreService.saveUser(user: user)
            await fetchUser()
            self.currentRole = roleEnum
            
        } catch let error as CreateValidator.CreateValidatorError {
            self.error = .custom(error)
            self.hasError = true
        } catch {
            self.error = .firestore("\(error.localizedDescription)")
            self.hasError = true
        }
    }
    
    func signOut() {
        authService.signOut()
        self.userSession = nil
        self.currentUser = nil
        self.currentRole = .member                                    
    }
    
    func fetchUser() async {
        let id = authService.getCurrentUserById()
        
        if id != nil {
            let user = await firestoreService.fetchUser(id: id!)
            self.currentUser = user
            self.currentRole = user?.role ?? .member

        } else {
            self.currentUser = nil
            self.currentRole = .member
        }
    }
    
    enum Validation: LocalizedError {
        case custom(CreateValidator.CreateValidatorError)
        case firestore(String)
        
        var errorDescription: String? {
            switch self {
            case .custom(let error):
                return error.localizedDescription
            case .firestore(_):
                return "Something went wrong!"
            }
        }
        
        var failureReason: String? {
            switch self {
            case .custom(let error):
                return error.failureReason
            case .firestore(let message):
                return message
            }
        }
    }
}
