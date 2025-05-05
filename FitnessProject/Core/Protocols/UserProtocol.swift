//
//  UserProtocol.swift
//  FitnessProject
//
//  Created by Wame Gassama on 26/04/2025.
//

import FirebaseAuth

protocol UserProtocol {
    var uid: String { get }
}

extension FirebaseAuth.User: UserProtocol {}
