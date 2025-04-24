import SwiftUI

struct EditEventView: View {
    let eventID: UUID
    @EnvironmentObject private var eventDataVM: EventDataViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var title       = ""
    @State private var duration    = 30
    @State private var trainer     = ""
    @State private var location    = ""
    @State private var slots       = 0
    @State private var date        = Date()
    @State private var description = ""

    // Hent event og popu­ler @State via onAppear
    private var event: EventModel {
        eventDataVM.events.first { $0.id == eventID }!
    }

    var body: some View {
        EventFormView(
            title: $title,
            duration: $duration,
            trainer: $trainer,
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
               EventTrainer: trainer,
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
        .navigationTitle("Rediger Event")
        .onAppear {
            title       = event.EventTitle
            duration    = event.EventDuration
            trainer     = event.EventTrainer
            location    = event.EventLocation
            slots       = event.EventSlots
            date        = event.EventDate
            description = event.EventDescription
        }
    }
}
