import SwiftUI

struct EventFullView: View {
    let eventID: UUID
    @EnvironmentObject private var eventDataVM: EventDataViewModel
    @StateObject   private var fullVM      = FullViewModel()
    @EnvironmentObject private var authVM: AuthViewModel          // ← NY
    @Environment(\.dismiss) private var dismiss

    /// Hvis event’et ikke findes (f.eks. lige efter slet), vis en tom tilstand og luk
    private var event: EventModel? {
        eventDataVM.events.first { $0.id == eventID }
    }

    var body: some View {
        Group {
            if let event = event {
                ScrollView {
                    VStack {
                        ZStack {
                            Image(event.EventPicture)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .cornerRadius(29)
                                .shadow(radius: 10)
                                .padding()
                            Text(event.EventTitle)
                                .foregroundColor(.white)
                                .font(.largeTitle)
                        }

                        HStack {
                            Label("\(event.EventDuration) min", systemImage: "clock")
                            Spacer()
                            Label(fullVM.formattedDate(for: event.EventDate),
                                  systemImage: "calendar")
                        }
                        .padding()

                        VStack(alignment: .leading, spacing: 40) {
                            HStack {
                                Label(event.EventLocation, systemImage: "location")
                                Spacer()
                                Label("\(event.EventMemembers.count)/\(event.EventSlots)",
                                      systemImage: "person.3")
                            }
                            Label(event.EventTrainerName, systemImage: "person")
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()

                        Divider()

                        Text(event.EventDescription)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                    }
                }
                .navigationTitle(event.EventTitle)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    // Rediger-knappen
                    ToolbarItem(placement: .navigationBarTrailing) {
                        if authVM.currentRole == .instructor {
                            NavigationLink("Rediger") {
                                EditEventView(eventID: eventID)
                            }
                        }
                    }
                    // Slet-knappen
                    ToolbarItem(placement: .bottomBar) {
                        if authVM.currentRole == .instructor {
                            Button("Slet eventet") {
                                eventDataVM.deleteEvent(event)
                                dismiss()
                            }
                            .foregroundColor(.red)
                        }
                    }
                }

            } else {
                // Når eventet er fjernet, luk viewet automatisk
                Color.clear
                    .onAppear { dismiss() }
            }
        }
    }
}

