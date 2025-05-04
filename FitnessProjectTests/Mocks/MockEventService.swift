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
            errorSubject.send("❌ Du har ikke tilladelse til at opdatere dette event.")
            return
        }
        
        guard let index = createdEvents.firstIndex(where: { $0.id == event.id }) else {
            errorSubject.send("❌ Event ikke fundet til opdatering.")
            return
        }
        
        createdEvents[index] = event
        eventsSubject.send(createdEvents)
    }
    
    func deleteEvent(_ event: EventModel) {
        guard mockCurrentUser?.id == event.EventTrainer else {
            errorSubject.send("❌ Du har ikke tilladelse til at slette dette event.")
            return
        }
        
        guard let index = createdEvents.firstIndex(where: { $0.id == event.id }) else {
            errorSubject.send("❌ Eventet blev ikke fundet til sletning")
            return
        }

        createdEvents.remove(at: index)
        eventsSubject.send(createdEvents)
    }
    
    func addMember(to eventID: String) {
        guard var currentUser = mockCurrentUser else {
            errorSubject.send("❌ Ikke logget ind!")
            return
        }
        
        guard let index = createdEvents.firstIndex(where: { $0.id.uuidString == eventID }) else {
            errorSubject.send("❌ Kan ikke tilføje medlem, event ikke fundet!")
            return
        }
        
        //Tilføjer brugerens id til EventMembers attributen som matcher eventID
        
        createdEvents[index].EventMemembers.append(currentUser.id)
        eventsSubject.send(createdEvents)
        
        //Tilføjer EventID'et i brugerens attendingEvents liste
        currentUser.attendingEvents.append(eventID)
        mockCurrentUser = currentUser
    }
    
    func removeMember(from eventID: String) {
        guard var currentUser = mockCurrentUser else {
            errorSubject.send("❌ Ikke logget ind!")
            return
        }
        
        //Fjerne brugeren fra EventsMembers
        guard let index = createdEvents.firstIndex(where: { $0.id.uuidString == eventID }) else {
            errorSubject.send("❌ Kunne ikke slette brugeren fra event!")
            return
        }
        
        createdEvents[index].EventMemembers.remove(at: index)
        eventsSubject.send(createdEvents)
        
        //Fjerner eventet fra AttendingEvent
        guard let userIndex = currentUser.attendingEvents.firstIndex(where: { $0 == eventID }) else {
            errorSubject.send("❌ Kunne ikke slette eventet fra AttendingEvent")
            return
        }
        
        currentUser.attendingEvents.remove(at: userIndex)
        mockCurrentUser = currentUser
    }
    
    
}
