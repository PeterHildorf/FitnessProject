//
//  EventCreateView.swift
//  FitnessProject
//
//  Created by Peter Hannibal Hildorf on 05/04/2025.
//

import SwiftUI

struct EventCreateView: View {
    @ObservedObject var viewModel: EventViewModel
    @Environment(\.dismiss) var dismiss  // Gør dig klar til at lukke viewet


    @State private var selectedType: String = "Fitness"
    
    private let trainingTypes = ["Fitness", "Run", "Yoga"]
    
    @State private var selectedHour: Int = 30
    private let trainingHours = [30,60,90,180]
    
    
    @State private var selectedName: String = "Peter Hildorf"
    private let trainNames = ["Peter Hildorf", "Victor Mandrup", "Mathias Larsen"]
    
    @State private var location = "" // En binding til tekstfeltet
    
    @State private var selectedMembers: Int = 10
    private let amountMembers = [5,10,15,20,25]
    
    @State private var date = Date.now

    @State private var description = ""
    
    
    
    var body: some View {
        ScrollView{
            VStack {
                Text("Opret Training Event")
                    .font(.headline)
                VStack(alignment: .leading, spacing: 8) {
                    Text("Event Title")
                        .font(.headline)
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.gray)
                        Picker("Vælg træningstype", selection: $selectedType) {
                            ForEach(trainingTypes, id: \.self) { type in
                                Text(type)
                                    .tag(type)  // hver option får en tag der matcher værdien
                            }
                        }
                        .pickerStyle(.menu)
                        .tint(.white)
                    }
                    .shadow(radius: 5)
                    Image(selectedType)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity) // = 350, pga. forælderens maxWidth
                        .cornerRadius(29)
                        .shadow(radius: 10)
                        .padding()
                    
                    
                    Label("Træningens varighed", systemImage: "clock")
                        .font(.headline)
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.gray)
                        Picker("", selection: $selectedHour){
                            ForEach(trainingHours, id: \.self){ time in
                                Text("\(time)" + " min")
                                    .tag(time)
                            }
                        }
                        .pickerStyle(.menu)
                        .tint(.white)
                    }
                    .shadow(radius: 5)
                    
                    Label("Vælg instruktør", systemImage: "person")
                        .font(.headline)
                    ZStack{
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.gray)
                        VStack{
                            Picker("", selection: $selectedName ){
                                ForEach(trainNames, id: \.self) { TName in
                                    Text("\(TName)")
                                        .tag(TName)
                                }
                                .pickerStyle(.menu)
                            }
                            .tint(.white)
                        }
                    }
                    .shadow(radius: 5)
                    Label("Antal deltagere", systemImage: "person.3")
                        .font(.headline)
                    ZStack{
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.gray)
                        VStack{
                            Picker("", selection: $selectedMembers ){
                                ForEach(amountMembers, id: \.self) { amount in
                                    Text("\(amount)")
                                        .tag(amount)
                                }
                            }
                            .pickerStyle(.segmented)
                            .tint(.white)
                        }
                    }
                    .shadow(radius: 5)
                    
                    Label("Eventets lokation", systemImage: "location")
                        .font(.headline)
                    TextField("Indtast lokation", text: $location)
                        .textFieldStyle(UnderlinedTextFieldStyle())
                    
                    HStack{
                        Label("Vælg dato", systemImage: "calendar")
                            .font(.headline)
                        DatePicker("", selection: $date)
                            .datePickerStyle(.compact)
                    }
                    Label("Beskrivelse", systemImage: "text.alignleft")
                        .font(.headline)
                    TextEditor(text: $description)
                        .outlinedTextEditorStyle()
                        .frame(height: 100)
                    ZStack{
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.gray)
                            .frame(height: 50)
                        Button("Tilføj Event"){
                            viewModel.createEvent(
                                eventTitle: selectedType,
                                eventDuration: selectedHour,
                                eventTrainer: selectedName,
                                eventLocation: location,
                                eventSlots: selectedMembers,
                                eventDate: date,
                                eventPicture: selectedType,
                                eventDescription: description)
                            dismiss()

                        }
                        .foregroundColor(.white)
                    }

                }
                .frame(maxWidth: 370, alignment: .leading)
                .padding()
                .navigationTitle("")

                
            }
        }
    }
}
struct UnderlinedTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(.vertical, 8)
            .background(
                VStack {
                    Spacer()
                    Color(UIColor.systemGray4)
                        .frame(height: 2)
                }
            )
    }
}

struct OutlinedTextEditorStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .stroke(Color(UIColor.systemGray4), lineWidth: 2)
            )
    }
}
extension View {
    func outlinedTextEditorStyle() -> some View {
        self.modifier(OutlinedTextEditorStyle())
    }
}

struct EventCreateView_Preview: PreviewProvider {
    static var previews: some View {
        EventCreateView(viewModel: EventViewModel(data: DataViewModel()))
    }
}
