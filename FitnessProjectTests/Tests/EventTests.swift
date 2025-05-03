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
    private var mockEventService: MockEventService = MockEventService()
    private var cancellables: Set<AnyCancellable> = []

    override func setUp() {
        super.setUp()
        viewModel = EventDataViewModel(service: mockEventService)
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testCreateEventSuccess() {
        let expectation = XCTestExpectation()

        let title = "Yoga"
        let duration = 60
        let trainerID = "trainer123"
        let trainerName = "Jane"
        let location = "Room A"
        let members: [String] = []
        let slots = 10
        let date = Date()
        let picture = "yoga.png"
        let description = "A relaxing yoga session."
        

        viewModel.$events
            .dropFirst()
            .sink { events in
                if let first = events.first {
                    XCTAssertEqual(events.count, 1)
                    XCTAssertEqual(first.EventTitle, title)
                    XCTAssertEqual(first.EventDuration, duration)
                    XCTAssertEqual(first.EventTrainer, trainerID)
                    XCTAssertEqual(first.EventTrainerName, trainerName)
                    XCTAssertEqual(first.EventLocation, location)
                    XCTAssertEqual(first.EventMemembers, members)
                    XCTAssertEqual(first.EventSlots, slots)
                    XCTAssertEqual(first.EventDate, date)
                    XCTAssertEqual(first.EventPicture, picture)
                    XCTAssertEqual(first.EventDescription, description)
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        viewModel.createEvent(
            title: title,
            duration: 60,
            trainerID: "trainer123",
            trainerName: "Jane",
            location: "Room A",
            members: [],
            slots: 10,
            date: date,
            picture: "yoga.png",
            description: "A relaxing yoga session."
        )

        wait(for: [expectation], timeout: 1.0)
    }
    
    func testUpdateEventByAuthorizedUser() {
        let expectation = XCTestExpectation()

        let originalEvent = EventModel(
            EventTitle: "Pilates",
            EventDuration: 60,
            EventTrainer: "mock_uid",
            EventTrainerName: "Jane",
            EventLocation: "DTU Lyngby",
            EventMemembers: [],
            EventSlots: 10,
            EventDate: Date(),
            EventPicture: "pilates.png",
            EventDescription: "Velkommen til pilates holdet!"
        )

        mockEventService.mockCurrentUser = User(
            id: "mock_uid",
            fullname: "Mock",
            email: "Mock@gmail.com",
            role: .instructor,
            createdEvents: [],
            attendingEvents: [])
        
        // Create the event
        mockEventService.createEvent(
            title: originalEvent.EventTitle,
            duration: originalEvent.EventDuration,
            trainerID: originalEvent.EventTrainer,
            trainerName: originalEvent.EventTrainerName,
            location: originalEvent.EventLocation,
            members: originalEvent.EventMemembers,
            slots: originalEvent.EventSlots,
            date: originalEvent.EventDate,
            picture: originalEvent.EventPicture,
            description: originalEvent.EventDescription
        )

        // Observe the events after creation and update
        viewModel.$events
            .dropFirst(3)
            .sink { events in
                if let updatedEvent = events.first {
                    XCTAssertEqual(updatedEvent.EventTitle, "Updated Title")
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        // Update the event
        let updatedEvent = EventModel(
            id: mockEventService.lastCreatedEvent!.id,
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
        
        // Wait for the expectation to be fulfilled
        wait(for: [expectation], timeout: 1.0)
    }

    func testDeleteEventByAuthorizedUser() {
        let expectation = XCTestExpectation(description: "Event burde værre slettet")

        let event = EventModel(
            EventTitle: "Zumba",
            EventDuration: 45,
            EventTrainer: "mock_uid",
            EventTrainerName: "Ana",
            EventLocation: "Studio B",
            EventMemembers: ["user1", "user2"],
            EventSlots: 20,
            EventDate: Date(),
            EventPicture: "zumba.png",
            EventDescription: "Join the Zumba fun!"
        )

        mockEventService.mockCurrentUser = User(
            id: "mock_uid",
            fullname: "Mock",
            email: "Mock@gmail.com",
            role: .instructor,
            createdEvents: [],
            attendingEvents: [])

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

        viewModel.$events
            .dropFirst(3)
            .sink { events in
                XCTAssertTrue(events.isEmpty, "Event burde værre slettet")
                expectation.fulfill()
            }
            .store(in: &cancellables)

        viewModel.deleteEvent(mockEventService.lastCreatedEvent!)

        wait(for: [expectation], timeout: 1.0)
    }
    
    func testAddMemberToEvent() {
        let expectation = XCTestExpectation()

        viewModel.createEvent(
            title: "Dancing",
            duration: 45,
            trainerID: "mock_uid",
            trainerName: "Gilli",
            location: "DTU Dancing Studio",
            members: [],
            slots: 20,
            date: Date(),
            picture: "dancing.png",
            description: "Join the dancing fun!")
        
        let eventID = mockEventService.lastCreatedEvent!.id.uuidString
        
        mockEventService.mockCurrentUser = User(
            id: "mock_uid",
            fullname: "Mock",
            email: "Mock@gmail.com",
            role: .instructor,
            createdEvents: [],
            attendingEvents: [])
        
        viewModel.addMember(to: eventID)
        
        let currentUser = mockEventService.mockCurrentUser
        
        viewModel.$events
            .dropFirst(3)
            .sink { events in
                if let event = events.first {
                    XCTAssertTrue(event.EventMemembers.contains(where: { $0 == currentUser?.id }))
                }
                XCTAssertTrue(currentUser!.attendingEvents.contains(where: {$0 == eventID}))
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testRemoveMember() {
        let expectation = XCTestExpectation()
        
        let userID = "member_uid"

        viewModel.createEvent(
            title: "Dancing",
            duration: 45,
            trainerID: "mock_uid",
            trainerName: "Gilli",
            location: "DTU Dancing Studio",
            members: [userID],
            slots: 20,
            date: Date(),
            picture: "dancing.png",
            description: "Join the dancing fun!")
        
        let eventID = mockEventService.lastCreatedEvent!.id.uuidString
        
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
    
}
