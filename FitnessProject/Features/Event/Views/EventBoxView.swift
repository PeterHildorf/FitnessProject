//
//  EventView.swift
//  FitnessProject
//
//  Created by Peter Hannibal Hildorf on 01/04/2025.
//


import SwiftUI
import Foundation

struct EventBoxView: View {
    
    @ObservedObject var data: DataViewModel        // <-- her får vi fat i din DataViewModel
    @State private var booked = false
    let event: EventModel
    
    let buttonWidth: CGFloat = 45
    let buttonHeight: CGFloat = 25
    
    // Dynamisk læsning af antal deltagere så vi sikre os at når der bliver ændrede i antallet af deltagerene i events så bliver det opdateret
    private var memberCount: Int {
        guard let idx = data.events.firstIndex(where: { $0.id == event.id }) else {
            return event.EventMemembers.count
        }
        return data.events[idx].EventMemembers.count
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
                    guard !isFull || booked else { return }
                    booked.toggle()
                    if booked {
                        data.addMember(to: event.id, member: "Alexander")     // indsæt den rigtige bruger‑streng her
                    } else {
                        data.removeMember(from: event.id, member: "Alexander")
                    }
                    print("Tryk")
                }) {
                    Group{
                        if isFull {
                            Text("Full")
                        }
                        else if booked {
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
        // Opret en preview‑instans af din DataViewModel
        let previewData = DataViewModel()
        // Giv EventBoxView både data og event
        EventBoxView(data: previewData,
                     event: EventModel.sampleData[0])
    }
}
