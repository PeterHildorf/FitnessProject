//
//  GuardedEventService.swift
//

import Foundation
import Combine

final class GuardedEventService: EventServiceProtocol {

    // MARK: - Private state
    private let inner: EventServiceProtocol
    private var currentRole: UserRole = .member
    private var cancellable: AnyCancellable?

    // MARK: - Init
    init(
        inner: EventServiceProtocol = FirestoreEventService(),
        rolePublisher: Published<UserRole>.Publisher
    ) {
        self.inner = inner
        // lyt til rolle-ændringer
        self.cancellable = rolePublisher
            .sink { [weak self] role in self?.currentRole = role }
    }

    // MARK: - Public publishers
    var eventsPublisher: AnyPublisher<[EventModel], Never>       { inner.eventsPublisher }
    var instructorsPublisher: AnyPublisher<[User], Never>        { inner.instructorsPublisher }

    // MARK: - CRUD med rolle-checks
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
        guard currentRole == .instructor else { return }
        inner.createEvent(
            title: title,
            duration: duration,
            trainerID: trainerID,
            trainerName: trainerName,
            location: location,
            members: members,
            slots: slots,
            date: date,
            picture: picture,
            description: description
        )
    }

    func updateEvent(_ e: EventModel) {
        guard currentRole == .instructor else { return }
        inner.updateEvent(e)
    }

    func deleteEvent(_ e: EventModel) {
        guard currentRole == .instructor else { return }
        inner.deleteEvent(e)
    }

    // Instruktør *og* medlem må booke/afmelde
    func addMember(to id: String)         { inner.addMember(to: id) }
    func removeMember(from id: String)    { inner.removeMember(from: id) }
}
