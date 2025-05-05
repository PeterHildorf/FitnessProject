//
//  User.swift
//  FitnessProject
//
//  Created by Wame Gassama on 14/04/2025.
//

import Foundation

enum UserRole: String, Codable {
    case instructor
    case member
}

typealias EventID = String


struct User: Identifiable, Codable, Hashable {
    let id: String
    let fullname: String
    let email: String
    var role: UserRole

    // The list of event IDs created by the instructor.
    var createdEvents: [EventID]

    // List of event IDs the member is registered for.

    var attendingEvents: [EventID]
    
    var initials: String {
        let formatter = PersonNameComponentsFormatter()
        if let components = formatter.personNameComponents(from: fullname) {
            formatter.style = .abbreviated
            return formatter.string(from: components)
        }
        
        return ""
    }
}
