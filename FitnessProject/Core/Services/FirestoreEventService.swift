// FirestoreEventService.swift

import Foundation
import Combine
import FirebaseFirestore
import FirebaseAuth

class FirestoreEventService: EventServiceProtocol {
    
    // Subjects som vi pusher nye data ind i
    private let eventsSubject      = CurrentValueSubject<[EventModel], Never>([])
    private let instructorsSubject = CurrentValueSubject<[User], Never>([])
    let errorSubject = PassthroughSubject<String, Never>()
    
    // Exponer som AnyPublisher
    var eventsPublisher: AnyPublisher<[EventModel], Never> {
        eventsSubject.eraseToAnyPublisher()
    }
    var instructorsPublisher: AnyPublisher<[User], Never> {
        instructorsSubject.eraseToAnyPublisher()
    }
    
    var errorPublisher: AnyPublisher<String, Never> {
        errorSubject.eraseToAnyPublisher()
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
        let eventRef = db.collection(eventsCol).document(docId)
        let trainerRef = db.collection(usersCol).document(trainerID)
        
        let batch = db.batch()
        
        batch.setData(new.dictionary, forDocument: eventRef)
        
        batch.updateData(["createdEvents": FieldValue.arrayUnion([docId])],
        forDocument: trainerRef
        )
        
        batch.commit { [weak self] error in
            if let err = error{
                self?.errorSubject.send("Kunne ikke oprette event: \(err.localizedDescription)")
            } }
        
        
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
        
        let batch = db.batch()
        let docId = event.id.uuidString
        let eventRef = db.collection(eventsCol).document(docId)
        
        //anvender batch igen for offline management (merge = true, gør at man bevare evt. andre felter)
        batch.setData(event.dictionary, forDocument: eventRef, merge: true)
        
        // sender/comitter batchen
        batch.commit { error in
            if let err = error {
                print("kunne ikke opdatere eventet", err.localizedDescription)
            }
        }
    }
    
    func deleteEvent(_ event: EventModel) {
        guard Auth.auth().currentUser?.uid == event.EventTrainer else { return }
        let docId = event.id.uuidString
        
        //Offline håndtering, opretter batch for alle de ændringer der skal gøres når funktionen kaldes offline:
        let batch = db.batch()
        // fjerner eventet for alle users der var en del af eventet
        for memberID in event.EventMemembers {
            let userRef = db.collection(usersCol).document(memberID)
            //skriver til batch
            batch.updateData(
                ["attendingEvents": FieldValue.arrayRemove([docId])],
                forDocument: userRef
            )
        }
        // fjerner eventID fra instructor liste af events
        let trainerRef = db.collection(usersCol).document(event.EventTrainer)
        //skriver til batch
        batch.updateData(["createdEvents": FieldValue.arrayRemove([docId])],
                         forDocument: trainerRef
        )
        
        // sletter selve dokumentet
        let eventRef = db.collection(eventsCol).document(docId)
        // skriver til batch
        batch.deleteDocument(eventRef)
        
        // sender/committer batch hvis en fejl sker i batchen, så går det ud over hele batchen og ingen ændringer sker
        batch.commit { [weak self] error in
            if let err = error {
                // anvender variablen errorSubject, så viewmodellen kan vise fejlen
                self?.errorSubject.send("Kunne ikke slette eventet: \(err.localizedDescription)")
            }
        }
    }
    
    
    func addMember(to eventID: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let eRef = db.collection(eventsCol).document(eventID)
        let uRef = db.collection(usersCol).document(uid)
        
        // 1) læg mig i EventMemembers
        eRef.updateData(["EventMemembers": FieldValue.arrayUnion([uid])]) { [weak self] error in
            if let err = error {
                // rollback roller antallet tilbage på eventet som det var før
                eRef.updateData(["EventMemembers": FieldValue.arrayRemove([uid])])
                self?.errorSubject.send("Kunne ikke tilmelde: \(err.localizedDescription)")
            }
        }
        
        // 2) læg event-id i min attendingEvents-liste
        uRef.updateData(["attendingEvents": FieldValue.arrayUnion([eventID])]) { [weak self] error in
            if let err = error {
                // rollback: opdatere useren's liste af events til hvad det var før
                uRef.updateData(["attendingEvents": FieldValue.arrayRemove([eventID])])
                self?.errorSubject.send("Kunne ikke tilføje til din event-liste: \(err.localizedDescription)")
            }
        }
    }
    
    
    
    
    func removeMember(from eventID: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let eRef = db.collection(eventsCol).document(eventID)
        let uRef = db.collection(usersCol).document(uid)
        
        eRef.updateData(["EventMemembers": FieldValue.arrayRemove([uid])]) {[weak self] error in
            if let err = error {
                // rollback: sætter user tilbage
                eRef.updateData(["EventMemembers": FieldValue.arrayUnion([uid])])
                self?.errorSubject.send("Kunne ikke afmelde fra event: \(err.localizedDescription)")
                return
                
            }
            uRef.updateData(["attendingEvents": FieldValue.arrayRemove([eventID])]) { [weak self] error in
                
                if let err = error {
                    // rollback: ligger eventID tilbage i user
                    self?.errorSubject.send("kunne ikke fjerne event fra user: \(err.localizedDescription)")
                    return
                }
                
            }
        }
    }
}
