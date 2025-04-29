//
//  EventCreateView.swift
//  FitnessProject
//
//  Created by Peter Hannibal Hildorf on 05/04/2025.
//

import SwiftUI

struct EventCreateView: View {
    @EnvironmentObject private var eventDataVM: EventDataViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var title             = "Fitness"
    @State private var duration          = 30
    @State private var selectedTrainer   = User(id: "", fullname: "", email: "", role: .instructor, createdEvents: [], attendingEvents: [])
    @State private var location          = ""
    @State private var slots             = 10
    @State private var date              = Date()
    @State private var description       = ""

    var body: some View {
        // Her er én sammenhængende View-instans
        EventFormView(
            title: $title,
            duration: $duration,
            selectedTrainer: $selectedTrainer,
            location: $location,
            slots: $slots,
            date: $date,
            description: $description,
            buttonTitle: "Opret Event"
        ) {
            eventDataVM.createEvent(
                title: title,
                duration: duration,
                trainer: selectedTrainer.id,
                trainerName: selectedTrainer.fullname,
                location: location,
                members: [],
                slots: slots,
                date: date,
                picture: title,
                description: description
            )
            dismiss()
        }
        .navigationTitle("Opret Event")    // ← nu indeni body
        .onAppear {
            if eventDataVM.instructors.first != nil && selectedTrainer.id.isEmpty {
                selectedTrainer = eventDataVM.instructors.first!
            }
        }
    }
}
