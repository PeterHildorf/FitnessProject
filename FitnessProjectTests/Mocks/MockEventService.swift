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

        if let index = createdEvents.firstIndex(where: { $0.id == event.id }) {
            createdEvents[index] = event
            eventsSubject.send(createdEvents)
        } else {
            errorSubject.send("❌ Event ikke fundet til opdatering.")
        }
    }
    
    func deleteEvent(_ event: EventModel) {
        guard mockCurrentUser?.id == event.EventTrainer else {
            errorSubject.send("❌ Du har ikke tilladelse til at slette dette event.")
            return
        }

        if let index = createdEvents.firstIndex(where: { $0.id == event.id }) {
            createdEvents.remove(at: index)
            eventsSubject.send(createdEvents)
        } else {
            errorSubject.send("❌ Eventet blev ikke fundet.")
        }
    }
    
    func addMember(to eventID: String) {
        guard var currentUser = mockCurrentUser else {
            errorSubject.send("❌ Ikke logget ind!")
            return
        }
        
        //Tilføjer brugerens id til EventMembers attributen som matcher eventID
        if let index = createdEvents.firstIndex(where: {$0.id.uuidString == eventID}) {
            createdEvents[index].EventMemembers.append(currentUser.id)
            eventsSubject.send(createdEvents)
        } else {
            errorSubject.send("❌ Event findes ikke!")
        }
        
        //Tilføjer EventID'et i brugerens attendingEvents liste
        currentUser.attendingEvents.append(eventID)
        mockCurrentUser = currentUser
    }
    
    func removeMember(from eventID: String) {
        guard var currentUser = mockCurrentUser else {
            errorSubject.send("❌ Ikke logget ind!")
            return
        }
        
        //Fjerner brugeren fra EventMembers attributten som macther eventID'et
        if let index = createdEvents.firstIndex(where: {$0.id.uuidString == eventID}) {
            createdEvents[index].EventMemembers.remove(at: index)
            eventsSubject.send(createdEvents)
        } else {
            errorSubject.send("❌ Kunne ikke slette brugeren fra event!")
        }
        
        //Fjerner eventet fra AttendingEvent
        if let userIndex = currentUser.attendingEvents.firstIndex(where: {$0 == eventID}) {
            currentUser.attendingEvents.remove(at: userIndex)
            mockCurrentUser = currentUser
        } else {
            errorSubject.send("❌ Kunne ikke slette eventet fra AttendingEvent")
        }
    }
    
    
}
