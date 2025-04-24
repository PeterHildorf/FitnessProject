//
//  EventView.swift
//  FitnessProject
//
//  Created by Peter Hannibal Hildorf on 01/04/2025.
//


import SwiftUI
import Foundation

struct EventBoxView: View {
    
    @EnvironmentObject private var eventDataVM: EventDataViewModel
    @State private var booked = false
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
        eventDataVM.events
          .first(where: { $0.id == event.id })?
          .EventMemembers
          .contains("Alexander") ?? false
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
            VStack(alignment: .leading) {
                
                Text(event.EventTitle)
                    .bold()
                Text("m/\(event.EventTrainer)")
                Text(event.EventLocation)
                    .font(.footnote)
            }
            
            
            Spacer()
            VStack{
                Button( action: {
                    //skal opdatere en liste
                    guard !isFull || isBooked else { return }
                    booked.toggle()
                    if isBooked {
                        eventDataVM.removeMember(from: event.id, member: "Alexander")
                    } else {
                        eventDataVM.addMember(to: event.id, member: "Alexander")
                    }
                }) {
                    Group{
                        if isFull && !isBooked {
                            Text("Full")
                        }
                        else if isBooked {
                            Image(systemName: "checkmark.circle.fill")
                        } else {
                            Text("Book")
                        }
                    }
                    .frame(minWidth: buttonWidth, minHeight: buttonHeight)
                    
                }
                .buttonStyle(.bordered)
                .tint(isFull ? .red : .blue)   // rød når fuld, blå ellers
                Label("\(memberCount)/\(event.EventSlots)", systemImage: "person")
                    .font(.footnote)
                
            }
        }
        .padding()
        
    }
}



struct EventBoxView_Previews: PreviewProvider {
    static var previews: some View {
        // Opret en preview-instans af EventDataViewModel og seed med sampleData
        let previewVM = EventDataViewModel()
        previewVM.events = EventModel.sampleData
        
        return EventBoxView(event: previewVM.events[0])
            .environmentObject(previewVM)
            .padding()
    }
}


