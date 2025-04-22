//
//  TrainerView.swift
//  FitnessProject
//
//  Created by Peter Hannibal Hildorf on 01/04/2025.
//


import SwiftUI

struct EventFullView: View {
    let event: EventModel
    @StateObject var viewModel = FullViewModel()
    @ObservedObject var dataViewModel: DataViewModel
    @StateObject var eventViewModel: EventViewModel
    
    @Environment(\.dismiss) var dismiss  // Gør dig klar til at lukke viewet

    
    
    var body: some View {
        ScrollView{
            VStack {
                ZStack {
                    //EventPicture
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
                    Label("\(event.EventDuration)"+" min",systemImage: "clock")
                    Spacer()
                    Label("\(viewModel.formattedDate(for: event.EventDate))", systemImage: "calendar")
                }
                .padding()
                VStack(alignment: .leading, spacing: 40){
                    HStack {
                        Label(event.EventLocation, systemImage: "location")
                        Spacer()
                        Label("\(event.EventMemembers.count)/\(event.EventSlots)", systemImage: "person.3")
                    }
                    Label (event.EventTrainer, systemImage: "person")
                    
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
        .toolbar {
            // Alternativt placeres knappen i en toolbar
            NavigationLink(destination: EditEventView(viewModel: EventViewModel(data: dataViewModel), event: event)) {
                Text("Rediger Event")
            }
        }
        .toolbar{
            ToolbarItem(placement: .bottomBar) {
                Button("Slet Eventet") {
                    eventViewModel.deleteEvents(event)
                    dismiss()
                }
            }
        }
    }
}

