//
//  EventDataViewModel.swift
//  FitnessProject
//
//  Created by Peter Hannibal Hildorf on 24/04/2025.
//

import Foundation
import Combine
import SwiftUI


class EventDataViewModel: ObservableObject {
    @Published var events: [EventModel] = []
    @Published var instructors: [User] = []
    @Published var lastError: String?

    
    @State private var booked = false
    
    private var cancellables = Set<AnyCancellable>()
    private let service: EventServiceProtocol
    

    init(service: EventServiceProtocol = FirestoreEventService()) {
        self.service = service

        service.eventsPublisher
          .receive(on: DispatchQueue.main)
          .assign(to: \.events, on: self)
          .store(in: &cancellables)

        service.instructorsPublisher
          .receive(on: DispatchQueue.main)
          .assign(to: \.instructors, on: self)
          .store(in: &cancellables)
        
        service.errorPublisher
            .map { Optional($0) }                 // String til String?
            .receive(on: DispatchQueue.main)
            .assign(to: \.lastError, on: self)
            .store(in: &cancellables)
      }
    
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
      ) {
        service.createEvent(
          title: title, duration: duration,
          trainerID: trainerID, trainerName: trainerName,
          location: location, members: members,
          slots: slots, date: date,
          picture: picture, description: description
        )
      }

      func updateEvent(_ event: EventModel) {
        service.updateEvent(event)
      }

      func deleteEvent(_ event: EventModel) {
        service.deleteEvent(event)
      }

      func addMember(to eventID: String) {
        service.addMember(to: eventID)
      }

      func removeMember(from eventID: String) {
        service.removeMember(from: eventID)
      }
    }
