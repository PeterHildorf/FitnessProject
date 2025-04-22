
import SwiftUI

class EventViewModel: ObservableObject {
    
    @ObservedObject var data: DataViewModel
    
    init(data: DataViewModel) {
        self.data = data
    }
    
    func createEvent(
        eventTitle: String,
        eventDuration: Int,
        eventTrainer: String,
        eventLocation: String,
        eventMemembers: [String] = [],
        eventSlots: Int,
        eventDate: Date,
        eventPicture: String,
        eventDescription: String
    ) {
        // Opretter en instans af EventModel direkte
        let newEvent = EventModel(EventTitle: eventTitle,
                                  EventDuration: eventDuration,
                                  EventTrainer: eventTrainer,
                                  EventLocation: eventLocation,
                                  EventMemembers: eventMemembers,
                                  EventSlots: eventSlots,
                                  EventDate: eventDate,
                                  EventPicture: eventPicture,
                                  EventDescription: eventDescription)
        data.events.append(newEvent)
        
        print("funktionen er kaldt")
    }
    
    func updateEvent(_ updatedEvent: EventModel){
        if let index = data.events.firstIndex(where: { $0.id == updatedEvent.id}) {
            data.events[index] = updatedEvent
            print("Event med titel '\(updatedEvent.EventTitle)' er opdateret.") 
        }
    }
    
    func deleteEvents (_ event: EventModel){
        if let index = data.events.firstIndex(where: { $0.id == event.id }) {
            data.events.remove(at: index)
            print("Event med titel '\(event.EventTitle)' er fjernet.")
            
        }
    }
    
    
    
}


