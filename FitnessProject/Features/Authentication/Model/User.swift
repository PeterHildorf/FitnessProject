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

    // Listen af event-IDs, som instructoren har oprettet
    var createdEvents: [EventID]

    // Listen af event-IDs, som useren har tilmeldt sig
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
