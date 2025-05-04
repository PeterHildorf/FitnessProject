//
//  EventView.swift
//  FitnessProject
//
//  Created by Peter Hannibal Hildorf on 01/04/2025.
//


import SwiftUI
import Foundation
import FirebaseAuth
struct EventBoxView: View {
    
    @EnvironmentObject private var eventDataVM: EventDataViewModel
    let event: EventModel
    
    let buttonWidth: CGFloat = 45
    let buttonHeight: CGFloat = 25
    
    // Læser altid live fra din EventDataViewModel.events-liste
    private var memberCount: Int {
        if let idx = eventDataVM.events.firstIndex(where: { $0.id == event.id }) {
            return eventDataVM.events[idx].EventMemembers.count
        } else {
            // Fald tilbage på det event-objekt, du fik sendt ind
            return event.EventMemembers.count
        }
    }
    
    private var isBooked: Bool {
        guard let uid = Auth.auth().currentUser?.uid else { return false }
        return eventDataVM.events
            .first(where: { $0.id == event.id })?
            .EventMemembers
            .contains(uid) ?? false
    }
    
    /// true når arrangementet er fyldt *og* jeg ikke er tilmeldt
    private var isLocked: Bool {
        isFull && !isBooked
    }

    private var isFull: Bool {
        memberCount >= event.EventSlots
    }
    
    // func til at ændre tiden til timer og minutter
    var formattedTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: event.EventDate)
    }
    
    var body: some View {
        HStack(){
            VStack(alignment: .leading) {
                Text(formattedTime)
                    .bold()
                Text("\(event.EventDuration) min")
                
            }
            Spacer()
            VStack(alignment: .trailing) {
                
                Text(event.EventTitle)
                    .bold()
                Text("m/\(event.EventTrainerName)")
                Text(event.EventLocation)
                    .font(.footnote)
            }
            
            
            Spacer()
            VStack{
                Button {
                    if isBooked {
                        eventDataVM.removeMember(from: event.id.uuidString)
                    } else {
                        eventDataVM.addMember(to: event.id.uuidString)
                    }
                } label: {
                    Group {
                        if isLocked {
                            Text("Full")
                        } else if isBooked {
                            Image(systemName: "checkmark.circle.fill")
                        } else {
                            Text("Book")
                        }
                    }
                    .frame(minWidth: buttonWidth, minHeight: buttonHeight)
                }
                .buttonStyle(.bordered)
                .tint(isLocked ? .red : .blue)
                .disabled(isLocked)
                Label("\(memberCount)/\(event.EventSlots)", systemImage: "person")
                    .font(.footnote)
                
            }
        }
        .padding()
        
    }
}


