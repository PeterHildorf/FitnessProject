// FirestoreEventService.swift

import Foundation
import Combine
import FirebaseFirestore
import FirebaseAuth

class FirestoreEventService: EventServiceProtocol {

  // Subjects som vi pusher nye data ind i
  private let eventsSubject      = CurrentValueSubject<[EventModel], Never>([])
  private let instructorsSubject = CurrentValueSubject<[User], Never>([])

  // Exponer som AnyPublisher
  var eventsPublisher: AnyPublisher<[EventModel], Never> {
    eventsSubject.eraseToAnyPublisher()
  }
  var instructorsPublisher: AnyPublisher<[User], Never> {
    instructorsSubject.eraseToAnyPublisher()
  }

  private let db = Firestore.firestore()
  private var eventsListener: ListenerRegistration?
  private var instrListener: ListenerRegistration?
  private let usersCol = "users"
  private let eventsCol = "events"

  init() {
    listenForEvents()
    listenForInstructors()
  }

  deinit {
    eventsListener?.remove()
    instrListener?.remove()
  }

  private func listenForEvents() {
    eventsListener = db.collection(eventsCol)
      .order(by: "EventDate")
      .addSnapshotListener { [weak self] snap, err in
        guard let docs = snap?.documents else { return }
        let models = docs.compactMap { EventModel(from: $0.data(), id: $0.documentID) }
        self?.eventsSubject.send(models)
      }
  }

  private func listenForInstructors() {
    instrListener = db.collection(usersCol)
      .whereField("role", isEqualTo: UserRole.instructor.rawValue)
      .addSnapshotListener { [weak self] snap, _ in
        guard let docs = snap?.documents else { return }
        let users = docs.compactMap { try? $0.data(as: User.self) }
        self?.instructorsSubject.send(users)
      }
  }

  // MARK: - CRUD

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
    let new = EventModel(
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
    let docId = new.id.uuidString

    db.collection(eventsCol).document(docId).setData(new.dictionary) { [weak self] error in
      if let err = error {
        print("❌ Kunne ikke oprette event:", err.localizedDescription)
        return
      }
      // opdater instruktør-dokument
      self?.db.collection(self!.usersCol)
        .document(trainerID)
        .updateData(["createdEvents": FieldValue.arrayUnion([docId])])
    }
  }

  func updateEvent(_ event: EventModel) {
    guard Auth.auth().currentUser?.uid == event.EventTrainer else { return }
    db.collection(eventsCol)
      .document(event.id.uuidString)
      .updateData(event.dictionary) { error in
        if let e = error { print("❌ Kunne ikke opdatere:", e.localizedDescription) }
      }
  }

  func deleteEvent(_ event: EventModel) {
    guard Auth.auth().currentUser?.uid == event.EventTrainer else { return }
    let docId = event.id.uuidString

    // fjern fra medlemmer
    event.EventMemembers.forEach { memberID in
      db.collection(usersCol)
        .document(memberID)
        .updateData(["attendingEvents": FieldValue.arrayRemove([docId])])
    }
    // fjern fra instruktør
    db.collection(usersCol)
      .document(event.EventTrainer)
      .updateData(["createdEvents": FieldValue.arrayRemove([docId])])
    // slet event
    db.collection(eventsCol)
      .document(docId)
      .delete { error in
        if let e = error { print("❌ Kunne ikke slette:", e.localizedDescription) }
      }
  }

  func addMember(to eventID: String) {
    guard let uid = Auth.auth().currentUser?.uid else { return }
    let eRef = db.collection(eventsCol).document(eventID)
    let uRef = db.collection(usersCol).document(uid)
    eRef.updateData(["EventMemembers": FieldValue.arrayUnion([uid])])
    uRef.updateData(["attendingEvents": FieldValue.arrayUnion([eventID])])
  }

  func removeMember(from eventID: String) {
    guard let uid = Auth.auth().currentUser?.uid else { return }
    let eRef = db.collection(eventsCol).document(eventID)
    let uRef = db.collection(usersCol).document(uid)
    eRef.updateData(["EventMemembers": FieldValue.arrayRemove([uid])])
    uRef.updateData(["attendingEvents": FieldValue.arrayRemove([eventID])])
  }
}
