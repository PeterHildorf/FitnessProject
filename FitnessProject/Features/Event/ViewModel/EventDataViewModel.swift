//
//  EventDataViewModel.swift
//  FitnessProject
//
//  Created by Peter Hannibal Hildorf on 24/04/2025.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import Combine

class EventDataViewModel: ObservableObject {
    // MARK: - Public published state
    @Published var events: [EventModel] = []
    @Published var instructors: [User] = []
    @State private var booked = false
    
    
    // MARK: - Firestore setup
    private let db = Firestore.firestore()
    private let usersCol  = "users"
    private let collection = "events"
    private var listener: ListenerRegistration?
    private var instrListener: ListenerRegistration?
    
    init() {
        listenForEvents()
        listenForInstructors()
        
    }
    deinit{
        // function til at stoppe lytteren/listeneren når viewmodellen ikke anvendes
        listener?.remove()
        instrListener?.remove()
        
    }
    
    // lytter functionen til events
    private func listenForEvents() {
        db.collection(collection)
            .order(by: "EventDate")
            .addSnapshotListener { snapshot, error in
                guard let docs = snapshot?.documents else {
                    print("❌ Firestore fejl:", error?.localizedDescription ?? "")
                    return
                }
                self.events = docs
                    .compactMap { doc in EventModel(from: doc.data(), id: doc.documentID) }
            }
    }
    // lytter funktionen til instructors
    private func listenForInstructors() {
        instrListener = db.collection(usersCol)
            .whereField("role", isEqualTo: UserRole.instructor.rawValue)
            .addSnapshotListener { snap, err in
                guard let docs = snap?.documents else { return }
                self.instructors = docs.compactMap { doc in
                    try? doc.data(as: User.self)    // kræver Codable + FirestoreSwift
                }
            }
    }
    
    // hjælpe funktion til at hente UserID
    private var currentUID: String? {
        Auth.auth().currentUser?.uid
    }
    
    // MARK: - CRUD
    // Instructor function
    func createEvent(
        title: String,
        duration: Int,
        trainer: UserID,
        trainerName: String,
        location: String,
        members: [UserID],
        slots: Int,
        date: Date,
        picture: String,
        description: String
    ) {        
        let new = EventModel(
            EventTitle: title,
            EventDuration: duration,
            EventTrainer: trainer,
            EventTrainerName: trainerName, 
            EventLocation: location,
            EventMemembers: members,
            EventSlots: slots,
            EventDate: date,
            EventPicture: picture,
            EventDescription: description
        )
        let docId = new.id.uuidString
        
        // Gem event i events-samlingen
        db.collection(collection)
            .document(docId)
            .setData(new.dictionary) { [weak self] error in
                if let e = error {
                    print("❌ Kunne ikke oprette event:", e.localizedDescription)
                } else {
                    // Tilføj event-ID til instruktørens createdEvents
                    self?.db.collection(self!.usersCol)
                        .document(trainer)
                        .updateData([
                            "createdEvents": FieldValue.arrayUnion([docId])
                        ])
                }
            }
    }
    
    // Instructor function
    func updateEvent(_ event: EventModel) {
        
        guard let uid = currentUID, uid == event.EventTrainer else { return }
        let docId = event.id.uuidString
        
        db.collection(collection)
            .document(docId)
            .updateData(event.dictionary) { error in
                if let e = error { print("❌ Kunne ikke opdatere:", e.localizedDescription) }
            }
    }
    // Instructor function
    func deleteEvent(_ event: EventModel) {
        guard let uid = currentUID, uid == event.EventTrainer else { return }
        let docId = event.id.uuidString
        
        // fjerner evetID fra alle user der members i deres attendarrays
        for memberID in event.EventMemembers {
            db.collection(usersCol)
            .document(memberID)
            .updateData([
              "attendingEvents": FieldValue.arrayRemove([docId])
            ])
        }
        // fjerner eventID fra instruktørens createdEvents array
        db.collection(usersCol)
            .document(uid)
            .updateData(["createdEvents": FieldValue.arrayRemove([docId])])
        
        // sletter eventet
        db.collection(collection)
            .document(docId)
            .delete { error in
                if let e = error { print("❌ Kunne ikke slette:", e.localizedDescription) }
            }
    }
    
    // Member function
    func addMember(to eventID: String) {
        guard let uid = currentUID else { return }
        let eventRef = db.collection(collection).document(eventID)
        let userRef  = db.collection(usersCol).document(uid)
        
        // 1 opdater event document
        eventRef.updateData([
            "EventMemembers": FieldValue.arrayUnion([uid])
        ])
        
        // 2 samme for user
        
        userRef.updateData([
            "attendingEvents": FieldValue.arrayUnion([eventID])
        ])
    }

    // Member function
    func removeMember(from eventID: String) {
        guard let uid = currentUID else { return }
        let eventRef = db.collection(collection).document(eventID)
        let userRef  = db.collection(usersCol).document(uid)
        // 1 for event document
        eventRef.updateData([
            "EventMemembers": FieldValue.arrayRemove([uid])
        ])
        // 2 for user 
        userRef.updateData([
            "attendingEvents": FieldValue.arrayRemove([eventID])
        ])
    }
}
