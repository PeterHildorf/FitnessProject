//
//  UserModel.swift
//  FitnessProject
//
//  Created by Peter Hannibal Hildorf on 18/04/2025.
//
import Foundation

struct UserModel: Identifiable {
    let id: UUID
    let name: String
    
    var bookedEvents: Set<UUID> = []
}
