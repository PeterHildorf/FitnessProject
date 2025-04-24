//
//  EventDataViewModel.swift
//  FitnessProject
//
//  Created by Peter Hannibal Hildorf on 24/04/2025.
//

import SwiftUI
import FirebaseFirestore
import Combine

class EventDataViewModel: ObservableObject {
    // MARK: - Public published state
    @Published var events: [EventModel] = []
    
    @State private var booked = false

    
    // MARK: - Firestore setup
    private let db = Firestore.firestore()
    private let collection = "events"
    
    init() {
        listenForEvents()
    }
    
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
    
    // MARK: - CRUD
    
    func createEvent(
        title: String,
        duration: Int,
        trainer: String,
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
            EventTrainer: trainer,
            EventLocation: location,
            EventMemembers: members,
            EventSlots: slots,
            EventDate: date,
            EventPicture: picture,
            EventDescription: description
        )
        let docId = new.id.uuidString
        db.collection(collection)
          .document(docId)
          .setData(new.dictionary) { error in
            if let e = error { print("❌ Kunne ikke oprette:", e.localizedDescription) }
        }
    }
    
    func updateEvent(_ event: EventModel) {
        let docId = event.id.uuidString
        db.collection(collection)
          .document(docId)
          .updateData(event.dictionary) { error in
            if let e = error { print("❌ Kunne ikke opdatere:", e.localizedDescription) }
        }
    }
    
    func deleteEvent(_ event: EventModel) {
        let docId = event.id.uuidString
        db.collection(collection)
          .document(docId)
          .delete { error in
            if let e = error { print("❌ Kunne ikke slette:", e.localizedDescription) }
        }
    }
    
    func addMember(to eventID: UUID, member: String) {
        let doc = db.collection(collection).document(eventID.uuidString)
        doc.updateData([
            "EventMemembers": FieldValue.arrayUnion([member])
        ])
    }
    
    func removeMember(from eventID: UUID, member: String) {
        let doc = db.collection(collection).document(eventID.uuidString)
        doc.updateData([
            "EventMemembers": FieldValue.arrayRemove([member])
        ])
    }
}
