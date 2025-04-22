//
//  User.swift
//  FitnessProject
//
//  Created by Wame Gassama on 14/04/2025.
//

import SwiftUI

struct User: Identifiable, Codable {
    let id: String
    let fullname: String
    let email: String
    let role: String
    
    var initials: String {
        let formatter = PersonNameComponentsFormatter()
        if let components = formatter.personNameComponents(from: fullname) {
            formatter.style = .abbreviated
            return formatter.string(from: components)
        }
        
        return ""
    }
}
