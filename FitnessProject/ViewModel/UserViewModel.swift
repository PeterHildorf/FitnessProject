//
//  UserViewModel.swift
//  FitnessProject
//
//  Created by Peter Hannibal Hildorf on 18/04/2025.
//
import Foundation
import Combine
class UserViewModel: ObservableObject {
    @Published private(set) var user: UserModel

    init(user: UserModel) {
            self.user = user
        }
    
    

}
