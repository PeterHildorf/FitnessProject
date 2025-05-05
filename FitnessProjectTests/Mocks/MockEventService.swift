//
//  MockEventService.swift
//  FitnessProject
//
//  Created by Wame Gassama on 03/05/2025.
//

import Combine
import Foundation

@testable import FitnessProject

class MockEventService: EventServiceProtocol {
    private let eventsSubject = CurrentValueSubject<[EventModel], Never>([])
    private let instructorsSubject = CurrentValueSubject<[User], Never>([])
    private let errorSubject = PassthroughSubject<String, Never>()

    var eventsPublisher: AnyPublisher<[EventModel], Never> {
        eventsSubject.eraseToAnyPublisher()
    }

    var instructorsPublisher: AnyPublisher<[User], Never> {
        instructorsSubject.eraseToAnyPublisher()
    }

    var errorPublisher: AnyPublisher<String, Never> {
        errorSubject.eraseToAnyPublisher()
    }
    
    var mockCurrentUser: User?
    var createdEvents: [EventModel] = []
    var lastCreatedEvent: EventModel?
    
    func createEvent(title: String, duration: Int, trainerID: String, trainerName: String, location: String, members: [String], slots: Int, date: Date, picture: String, description: String) {
        
        let newEvent = EventModel(
            id: UUID(),
            EventTitle: title,
            EventDuration: duration,
            EventTrainer: trainerID,
            EventTrainerName: trainerName,
            EventLocation: location,
            EventMemembers: members,
            EventSlots: slots,
            EventDate: date,
            EventPicture: picture,
            EventDescription: description
        )
        
        createdEvents.append(newEvent)
        lastCreatedEvent = newEvent
        
        eventsSubject.send(createdEvents)
    }
    
    func updateEvent(_ event: EventModel) {
        guard mockCurrentUser?.id == event.EventTrainer else {
            errorSubject.send("❌ You do not have permission to update this event.")
            return
        }
        
        guard let index = createdEvents.firstIndex(where: { $0.id == event.id }) else {
            errorSubject.send("❌ Event not found for update.")
            return
        }
        
        createdEvents[index] = event
        eventsSubject.send(createdEvents)
    }
    
    func deleteEvent(_ event: EventModel) {
        guard mockCurrentUser?.id == event.EventTrainer else {
            errorSubject.send("❌ You do not have permission to delete this event.")
            return
        }
        
        guard let index = createdEvents.firstIndex(where: { $0.id == event.id }) else {
            errorSubject.send("❌ The event was not found for deletion")
            return
        }

        createdEvents.remove(at: index)
        eventsSubject.send(createdEvents)
    }
    
    func addMember(to eventID: String) {
        guard var currentUser = mockCurrentUser else {
            errorSubject.send("❌ Not signed in!")
            return
        }
        
        guard let index = createdEvents.firstIndex(where: { $0.id.uuidString == eventID }) else {
            errorSubject.send("❌ Cannot add member, event not found!")
            return
        }
        
        createdEvents[index].EventMemembers.append(currentUser.id)
        eventsSubject.send(createdEvents)
        
        currentUser.attendingEvents.append(eventID)
        mockCurrentUser = currentUser
    }
    
    func removeMember(from eventID: String) {
        guard var currentUser = mockCurrentUser else {
            errorSubject.send("❌ Not signed in!")
            return
        }
        
        //Fjerne brugeren fra EventsMembers
        guard let index = createdEvents.firstIndex(where: { $0.id.uuidString == eventID }) else {
            errorSubject.send("❌ Could not remove the user from the event!")
            return
        }
        
        createdEvents[index].EventMemembers.remove(at: index)
        eventsSubject.send(createdEvents)
        
        //Fjerner eventet fra AttendingEvent
        guard let userIndex = currentUser.attendingEvents.firstIndex(where: { $0 == eventID }) else {
            errorSubject.send("❌ Could not delete the event from AttendingEvent")
            return
        }
        
        currentUser.attendingEvents.remove(at: userIndex)
        mockCurrentUser = currentUser
    }
    
    
}
