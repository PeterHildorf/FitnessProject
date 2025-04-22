//
//  CreateValidator.swift
//  FitnessProject
//
//  Created by Wame Gassama on 14/04/2025.
//

import Foundation

struct CreateValidator {
    func validate(_ email: String,_ password: String) throws {
        if email.isEmpty {
            throw CreateValidatorError.emptyEmail
        }
        
        let emailRegex = "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,64}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES[c] %@", emailRegex)
        
        if !emailPredicate.evaluate(with: email) {
            throw CreateValidatorError.invalidEmail
        }
        
        if password.isEmpty {
            throw CreateValidatorError.emptyPassword
        }
        
        if password.count < 6 {
            throw CreateValidatorError.invalidPassword
        }
    }
}

extension CreateValidator {
    enum CreateValidatorError: LocalizedError {
        case authFailed
        case emptyEmail
        case invalidEmail
        case emptyPassword
        case invalidPassword
        
        var errorDescription: String? {
            switch self {
            case .authFailed:
                return "Unable to Sign In"
            case .emptyEmail:
                return "Invalid Email"
            case .invalidEmail:
                return "Invalid Email"
            case .emptyPassword:
                return "Invalid Password"
            case .invalidPassword:
                return "Invalid Password"
            }
        }
        
        var failureReason: String? {
            switch self {
            case .authFailed:
                return "Incorrect email or password. Please try again."
            case .emptyEmail:
                return "Email address is required"
            case .invalidEmail:
                return "Please type a valid email address"
            case .emptyPassword:
                return "Password is required"
            case .invalidPassword:
                return "Password must be at least 6 characters long"
            }
        }
    }
}
