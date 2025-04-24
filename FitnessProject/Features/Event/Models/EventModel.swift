import Foundation
import FirebaseFirestore

struct EventModel: Identifiable, Hashable {
    let id: UUID
    var EventTitle: String
    var EventDuration: Int
    var EventTrainer: String
    var EventLocation: String
    var EventMemembers: [String]
    var EventSlots: Int
    var EventDate: Date
    var EventPicture: String
    var EventDescription: String

    init(
      id: UUID = UUID(),
      EventTitle: String,
      EventDuration: Int,
      EventTrainer: String,
      EventLocation: String,
      EventMemembers: [String],
      EventSlots: Int,
      EventDate: Date,
      EventPicture: String,
      EventDescription: String
    ) {
        self.id = id
        self.EventTitle     = EventTitle
        self.EventDuration  = EventDuration
        self.EventTrainer   = EventTrainer
        self.EventLocation  = EventLocation
        self.EventMemembers = EventMemembers
        self.EventSlots     = EventSlots
        self.EventDate      = EventDate
        self.EventPicture   = EventPicture
        self.EventDescription = EventDescription
    }
}

extension EventModel {
    /// Gør modellen klar til at gemme i Firestore
    var dictionary: [String: Any] {
        return [
          "EventTitle":     EventTitle,
          "EventDuration":  EventDuration,
          "EventTrainer":   EventTrainer,
          "EventLocation":  EventLocation,
          "EventMemembers": EventMemembers,
          "EventSlots":     EventSlots,
          // Husk at konvertere Date til Firestore Timestamp
          "EventDate":      Timestamp(date: EventDate),
          "EventPicture":   EventPicture,
          "EventDescription": EventDescription
        ]
    }

    /// Initialiser fra Firestore-data + dokument-ID
    init?(from dict: [String: Any], id: String) {
        guard
          let title    = dict["EventTitle"]     as? String,
          let duration = dict["EventDuration"]  as? Int,
          let trainer  = dict["EventTrainer"]   as? String,
          let location = dict["EventLocation"]  as? String,
          let members  = dict["EventMemembers"] as? [String],
          let slots    = dict["EventSlots"]     as? Int,
          let ts       = dict["EventDate"]      as? Timestamp,
          let picture  = dict["EventPicture"]   as? String,
          let desc     = dict["EventDescription"] as? String,
          let uuid     = UUID(uuidString: id)
        else {
          return nil
        }

        self.id             = uuid
        self.EventTitle     = title
        self.EventDuration  = duration
        self.EventTrainer   = trainer
        self.EventLocation  = location
        self.EventMemembers = members
        self.EventSlots     = slots
        self.EventDate      = ts.dateValue()
        self.EventPicture   = picture
        self.EventDescription = desc
    }

    /// Sample data til previews og tests
    static let sampleData: [EventModel] = {
        let now = Date()
        return [
            EventModel(
                EventTitle: "Fitness Session",
                EventDuration: 60,
                EventTrainer: "Peter Hildorf",
                EventLocation: "Amager Strand",
                EventMemembers: ["Alice", "Bob"],
                EventSlots: 20,
                EventDate: now,
                EventPicture: "Fitness",
                EventDescription: "Kom og træn med os på stranden!"
            ),
            EventModel(
                EventTitle: "Yoga Class",
                EventDuration: 45,
                EventTrainer: "Maria Jensen",
                EventLocation: "Nørrebro Center",
                EventMemembers: ["Charlie"],
                EventSlots: 15,
                EventDate: Calendar.current.date(byAdding: .day, value: 1, to: now)!,
                EventPicture: "Yoga",
                EventDescription: "Find ro med guidet yoga."
            ),
            EventModel(
                EventTitle: "Running Group",
                EventDuration: 30,
                EventTrainer: "Lars Olsen",
                EventLocation: "Frederiksberg Gym",
                EventMemembers: ["Diana", "Evan"],
                EventSlots: 10,
                EventDate: Calendar.current.date(byAdding: .day, value: 2, to: now)!,
                EventPicture: "Run",
                EventDescription: "Løb en frisk tur i parken."
            )
        ]
    }()
}
