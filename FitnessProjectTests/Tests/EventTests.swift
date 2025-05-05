//
//  EventTests.swift
//  FitnessProjectTests
//
//  Created by Wame Gassama on 03/05/2025.
//

@testable import FitnessProject

import XCTest
import Combine

final class EventTests: XCTestCase {
    private var viewModel: EventDataViewModel!
    private var mockEventService: MockEventService!
    private var cancellables: Set<AnyCancellable> = []

    override func setUp() {
        super.setUp()
        mockEventService = MockEventService()
        viewModel = EventDataViewModel(service: mockEventService)
    }
    
    override func tearDown() {
        viewModel = nil
        mockEventService = nil
        super.tearDown()
    }
    
    func testCreateEvent() {
        let expectation = XCTestExpectation()
        let event = createMockEvent()

        viewModel.$events
            .dropFirst()
            .sink { events in
                if let first = events.first {
                    XCTAssertEqual(events.count, 1)
                    XCTAssertEqual(first.EventTitle, event.EventTitle)
                    XCTAssertEqual(first.EventDuration, event.EventDuration)
                    XCTAssertEqual(first.EventTrainer, event.EventTrainer)
                    XCTAssertEqual(first.EventTrainerName, event.EventTrainerName)
                    XCTAssertEqual(first.EventLocation, event.EventLocation)
                    XCTAssertEqual(first.EventMemembers, event.EventMemembers)
                    XCTAssertEqual(first.EventSlots, event.EventSlots)
                    XCTAssertEqual(first.EventDate, event.EventDate)
                    XCTAssertEqual(first.EventPicture, event.EventPicture)
                    XCTAssertEqual(first.EventDescription, event.EventDescription)
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1.0)
    }
    
    func testUpdateEventByAuthorizedUser() {
        let expectation = XCTestExpectation(description: "Expecting the event to be updated")

        let currentUser = createMockUser()
        
        let originalEvent = createMockEvent(EventTrainer: currentUser.id)

        let updatedEvent = EventModel(
            id: originalEvent.id,
            EventTitle: "Updated Title",
            EventDuration: originalEvent.EventDuration,
            EventTrainer: originalEvent.EventTrainer,
            EventTrainerName: originalEvent.EventTrainerName,
            EventLocation: originalEvent.EventLocation,
            EventMemembers: originalEvent.EventMemembers,
            EventSlots: originalEvent.EventSlots,
            EventDate: originalEvent.EventDate,
            EventPicture: originalEvent.EventPicture,
            EventDescription: originalEvent.EventDescription
        )
        
        // Perform the update
        viewModel.updateEvent(updatedEvent)
        
        viewModel.$events
            .dropFirst(3)
            .sink { events in
                if let updatedEvent = events.first {
                    XCTAssertEqual(updatedEvent.EventTitle, "Updated Title")
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        // Wait for the expectation to be fulfilled
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testUpdateEventByUnauthorizedUser() {
        let expectation = XCTestExpectation(description: "Expecting that an event cannot be updated")
        
        createMockUser()
        
        let originalEvent = createMockEvent(EventTrainer: "wrongUserId")
        
        let updatedEvent = EventModel(
            id: originalEvent.id,
            EventTitle: "Updated Title",
            EventDuration: originalEvent.EventDuration,
            EventTrainer: originalEvent.EventTrainer,
            EventTrainerName: originalEvent.EventTrainerName,
            EventLocation: originalEvent.EventLocation,
            EventMemembers: originalEvent.EventMemembers,
            EventSlots: originalEvent.EventSlots,
            EventDate: originalEvent.EventDate,
            EventPicture: originalEvent.EventPicture,
            EventDescription: originalEvent.EventDescription
        )
        
        viewModel.updateEvent(updatedEvent)
        
        viewModel.$lastError
            .dropFirst()
            .sink { error in
                if let error = error {
                    XCTAssertEqual(error.description, "❌ You do not have permission to update this event.")
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testEventNotFoundForUpdateEvent() {
        let nonExistentEvent = createMockEventModel()
        
        eventNotFound(when: viewModel.updateEvent, nonExistentEvent, "❌ Event not found for update.", "Expected to fail, as the event does not exist")
    }

    func testDeleteEventByAuthorizedUser() {
        let expectation = XCTestExpectation(description: "Expected the event to be deleted")

        let currentUser = createMockUser()
        
        let lastCreatedEvent = createMockEvent(EventTrainer: currentUser.id)

        viewModel.deleteEvent(lastCreatedEvent)
        
        viewModel.$events
            .dropFirst(3)
            .sink { events in
                XCTAssertFalse(events.contains(where: {$0.id == lastCreatedEvent.id}))
                expectation.fulfill()
            }
            .store(in: &cancellables)


        wait(for: [expectation], timeout: 1.0)
    }
    
    func testDeleteEventByUnauthorizedUser() {
        let expectation = XCTestExpectation(description: "Expecting that events cannot be deleted by non-authorized users")

        createMockUser()
        
        let lastCreatedEvent = createMockEvent(EventTrainer: "wrong_uid")

        viewModel.deleteEvent(lastCreatedEvent)
        
        viewModel.$lastError
            .dropFirst()
            .sink { error in
                if let error = error {
                    XCTAssertEqual(error.description, "❌ You do not have permission to delete this event.")
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)


        wait(for: [expectation], timeout: 1.0)
    }
    
    func testEventNotFoundForDeleteEvent() {
        let nonExistentEvent = createMockEventModel()
        
        eventNotFound(when: viewModel.deleteEvent, nonExistentEvent, "❌ The event was not found for deletion", "Expecting that an event cannot be deleted")
    }
    
    func testAddMemberToEvent() {
        let expectation = XCTestExpectation(description: "Expecting that events will be added to the user and the user will be added to the event")

        let lastCreatedEvent = createMockEvent()
        
        let eventID = lastCreatedEvent.id.uuidString
        
        createMockUser(id: lastCreatedEvent.id.uuidString)
        
        viewModel.addMember(to: eventID)
        
        
        viewModel.$events
            .dropFirst(3)
            .sink { events in
                if let event = events.first {
                    XCTAssertTrue(event.EventMemembers.contains(where: { $0 == self.mockEventService.mockCurrentUser?.id }) == true)
                }
                XCTAssertTrue(self.mockEventService.mockCurrentUser?.attendingEvents.contains(where: { $0 == eventID }) == true)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testEventNotFoundForAddMember() {
        let nonExistentEvent = createMockEventModel()
        
        eventNotFound(when: nil, when: viewModel.addMember, nonExistentEvent, "❌ Cannot add member, event not found!", "Expecting that a member cannot be added, as the event was not found.")
    }
    
    func testMemberNotLoggedIn() {
        let expectation = XCTestExpectation()

        let lastCreatedEvent = createMockEvent()
        
        let eventID = lastCreatedEvent.id.uuidString
        
        viewModel.addMember(to: eventID)
                
        viewModel.$lastError
            .dropFirst()
            .sink { error in
                if let error = error {
                    XCTAssertEqual(error.description, "❌ Not signed in!")
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testRemoveMember() {
        let expectation = XCTestExpectation()
        
        let userID = "member_uid"
        
        let lastCreatedEvent = createMockEvent(EventMemembers: [userID])
        
        let eventID = lastCreatedEvent.id.uuidString
        
        mockEventService.mockCurrentUser = User(
            id: "mock_uid",
            fullname: "Mock",
            email: "Mock@gmail.com",
            role: .instructor,
            createdEvents: [],
            attendingEvents: [eventID])
        
        viewModel.removeMember(from: eventID)
        
        let currentUser = mockEventService.mockCurrentUser
        
        viewModel.$events
            .dropFirst(3)
            .sink { events in
                if let event = events.first {
                    XCTAssertFalse(event.EventMemembers.contains(where: { $0 == currentUser?.id }))
                }
                XCTAssertFalse(currentUser!.attendingEvents.contains(where: {$0 == eventID}))
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    
    // MARK: - Helpers
    
    func eventNotFound(
        when performingForEventModel: ((_ event: EventModel) -> Void)? = nil,
        when performingForEventID: ((_ id: String) -> Void)? = nil,
        _ data: EventModel,
        _ expectedErrorMessage: String,
        _ expectationMessage: String
    ) {
            let expectation = XCTestExpectation(description: expectationMessage)
            
            createMockUser()
            
            createMockEvent()
            
            viewModel.$lastError
                .dropFirst()
                .sink { error in
                    if let error = error {
                        XCTAssertEqual(error.description, expectedErrorMessage)
                        expectation.fulfill()
                    }
                }
                .store(in: &cancellables)
        
            if let callingMethodWithEventModel = performingForEventModel {
                callingMethodWithEventModel(data)
            } else if let callingMethodWithEventId = performingForEventID {
                callingMethodWithEventId(data.id.uuidString)
            }
            
            
            wait(for: [expectation], timeout: 1.0)
    }
    
    @discardableResult
    private func createMockEventModel(
        id: UUID? = nil,
        EventTitle: String = "Pilates",
        EventDuration: Int = 60,
        EventTrainer: String = "mock_uid",
        EventTrainerName: String = "John Doe",
        EventLocation: String = "DTU Lyngby",
        EventMemembers: [String] = [],
        EventSlots: Int = 10,
        EventDate: Date = Date(),
        EventPicture: String = "event.png",
        EventDescription: String = "Description"
    ) -> EventModel {
        let event = EventModel(
            id: id ?? UUID(),
            EventTitle: EventTitle,
            EventDuration: EventDuration,
            EventTrainer: EventTrainer,
            EventTrainerName: EventTrainerName,
            EventLocation: EventLocation,
            EventMemembers: EventMemembers,
            EventSlots: EventSlots,
            EventDate: Date(),
            EventPicture: EventPicture,
            EventDescription: EventDescription
        )
        
        return event
    }
    
    @discardableResult
    private func createMockEvent(
        id: UUID? = nil,
        EventTitle: String = "Pilates",
        EventDuration: Int = 60,
        EventTrainer: String = "mock_uid",
        EventTrainerName: String = "John Doe",
        EventLocation: String = "DTU Lyngby",
        EventMemembers: [String] = [],
        EventSlots: Int = 10,
        EventDate: Date = Date(),
        EventPicture: String = "event.png",
        EventDescription: String = "Description"
    ) -> EventModel {
        
        let event = createMockEventModel(
            id: id,
            EventTitle: EventTitle,
            EventDuration: EventDuration,
            EventTrainer: EventTrainer,
            EventTrainerName: EventTrainerName,
            EventLocation: EventLocation,
            EventMemembers: EventMemembers,
            EventSlots: EventSlots,
            EventDate: EventDate,
            EventPicture: EventPicture,
            EventDescription: EventDescription
        )
        
        mockEventService.createEvent(
            title: event.EventTitle,
            duration: event.EventDuration,
            trainerID: event.EventTrainer,
            trainerName: event.EventTrainerName,
            location: event.EventLocation,
            members: event.EventMemembers,
            slots: event.EventSlots,
            date: event.EventDate,
            picture: event.EventPicture,
            description: event.EventDescription
        )
        return mockEventService.lastCreatedEvent!
    }
    
    @discardableResult
    private func createMockUser(
        id: String = "mock_uid",
        fullname: String = "Mock",
        email: String = "Mock@gmail.com",
        createdEvents: [String] = [],
        attendingEvents: [String] = []
    ) -> User {
        mockEventService.mockCurrentUser = User(
            id: id,
            fullname: fullname,
            email: email,
            role: .instructor,
            createdEvents: createdEvents,
            attendingEvents: attendingEvents)
        
        return mockEventService.mockCurrentUser!
    }
    
}
