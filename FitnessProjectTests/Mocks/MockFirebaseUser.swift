//
//  MockFirebaseUser.swift
//  FitnessProject
//
//  Created by Wame Gassama on 26/04/2025.
//

@testable import FitnessProject

class MockFirebaseUser: UserProtocol {
    var uid: String
    
    init(_ uid: String) {
        self.uid = uid
    }
}
