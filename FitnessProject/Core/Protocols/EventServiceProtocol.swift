//
//  EventServiceProtocol.swift
//  FitnessProject
//
//  Created by Peter Hannibal Hildorf on 29/04/2025.
//

import Combine
import FirebaseAuth

protocol EventServiceProtocol {
    // Definere at der kan komme events og instructors fra protocollen
    var eventsPublisher: AnyPublisher<[EventModel], Never> { get }
    var instructorsPublisher: AnyPublisher<[User], Never> { get }
    
    func createEvent(
        title: String,
        duration: Int,
        trainerID: String,
        trainerName: String,
        location: String,
        members: [String],
        slots: Int,
        date: Date,
        picture: String,
        description: String
      )
    
    func updateEvent(_ event: EventModel)
    func deleteEvent(_ event: EventModel)
    func addMember(to eventID: String)
    func removeMember(from eventID: String)

}
