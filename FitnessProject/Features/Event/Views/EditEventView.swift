import SwiftUI

struct EditEventView: View {
    let eventID: UUID
    @EnvironmentObject private var eventDataVM: EventDataViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var title             = ""
    @State private var duration          = 30
    @State private var selectedTrainer   = User(id: "", fullname: "", email: "", role: .instructor, createdEvents: [], attendingEvents: [])
    @State private var location          = ""
    @State private var slots             = 0
    @State private var date              = Date()
    @State private var description       = ""

    private var event: EventModel {
        eventDataVM.events.first { $0.id == eventID }!
    }

    var body: some View {
        EventFormView(
            title: $title,
            duration: $duration,
            selectedTrainer: $selectedTrainer,
            location: $location,
            slots: $slots,
            date: $date,
            description: $description,
            buttonTitle: "Opdater Event"
        ) {
            let updated = EventModel(
                id: event.id,
                EventTitle: title,
                EventDuration: duration,
                EventTrainer: selectedTrainer.id,
                EventTrainerName: selectedTrainer.fullname,
                EventLocation: location,
                EventMemembers: event.EventMemembers,
                EventSlots: slots,
                EventDate: date,
                EventPicture: title,
                EventDescription: description
            )
            eventDataVM.updateEvent(updated)
            dismiss()
        }
        .navigationTitle("Rediger Event")   // ← indeni body
        .onAppear {
            title       = event.EventTitle
            duration    = event.EventDuration
            location    = event.EventLocation
            slots       = event.EventSlots
            date        = event.EventDate
            description = event.EventDescription

            if let instr = eventDataVM.instructors.first(where: { $0.id == event.EventTrainer }) {
                selectedTrainer = instr
            }
        }
    }
}
