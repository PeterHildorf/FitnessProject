import Foundation
import FirebaseFirestore

typealias UserID = String


struct EventModel: Identifiable, Hashable {
    let id: UUID
    var EventTitle: String
    var EventDuration: Int
    var EventTrainer: UserID
    var EventTrainerName: String
    var EventLocation: String
    var EventMemembers: [UserID]
    var EventSlots: Int
    var EventDate: Date
    var EventPicture: String
    var EventDescription: String

    init(
      id: UUID = UUID(),
      EventTitle: String,
      EventDuration: Int,
      EventTrainer: UserID,
      EventTrainerName: String,
      EventLocation: String,
      EventMemembers: [UserID],
      EventSlots: Int,
      EventDate: Date,
      EventPicture: String,
      EventDescription: String
    ) {
        self.id = id
        self.EventTitle     = EventTitle
        self.EventDuration  = EventDuration
        self.EventTrainer   = EventTrainer
        self.EventTrainerName = EventTrainerName
        self.EventLocation  = EventLocation
        self.EventMemembers = EventMemembers
        self.EventSlots     = EventSlots
        self.EventDate      = EventDate
        self.EventPicture   = EventPicture
        self.EventDescription = EventDescription
    }
}

extension EventModel {
    var dictionary: [String: Any] {
        return [
            "EventTitle":     EventTitle,
            "EventDuration":  EventDuration,
            "EventTrainer":   EventTrainer,
            "EventTrainerName": EventTrainerName,
            "EventLocation":  EventLocation,
            "EventMemembers": EventMemembers,
            "EventSlots":     EventSlots,
            // Husk at konvertere Date til Firestore Timestamp
            "EventDate":      Timestamp(date: EventDate),
            "EventPicture":   EventPicture,
            "EventDescription": EventDescription
        ]
    }
    
    init?(from dict: [String: Any], id: String) {
        guard
            let title    = dict["EventTitle"]     as? String,
            let duration = dict["EventDuration"]  as? Int,
            let trainer  = dict["EventTrainer"]   as? UserID,
            let trainerName = dict["EventTrainerName"] as? String,
            let location = dict["EventLocation"]  as? String,
            let members  = dict["EventMemembers"] as? [UserID],
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
        self.EventTrainerName = trainerName
        self.EventLocation  = location
        self.EventMemembers = members
        self.EventSlots     = slots
        self.EventDate      = ts.dateValue()
        self.EventPicture   = picture
        self.EventDescription = desc
    }
}

    
