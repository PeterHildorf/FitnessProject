
import SwiftUI

struct EditEventView: View {
    @ObservedObject var viewModel: EventViewModel
    var event: EventModel

    @Environment(\.dismiss) var dismiss  // Gør dig klar til at lukke viewet
    
    
    @State private var eventTitle: String
    @State private var eventDuration: Int
    @State private var eventTrainer: String
    @State private var eventLocation: String
    @State private var eventSlots: Int
    @State private var eventDate: Date
    @State private var eventPicture: String
    @State private var eventDescription: String

    private let availableTypes = ["Fitness", "Run", "Yoga"]
    private let availableDurations = [30, 60, 90, 180]
    private let availableTrainers = ["Peter Hildorf", "Victor Mandrup", "Mathias Larsen"]
    private let availableSlots = [5, 10, 15, 20, 25]
    
    init(viewModel: EventViewModel, event: EventModel) {
            self.viewModel = viewModel
            self.event = event
            _eventTitle = State(initialValue: event.EventTitle)
            _eventDuration = State(initialValue: event.EventDuration)
            _eventTrainer = State(initialValue: event.EventTrainer)
            _eventLocation = State(initialValue: event.EventLocation)
            _eventSlots = State(initialValue: event.EventSlots)
            _eventDate = State(initialValue: event.EventDate)
            _eventPicture = State(initialValue: event.EventPicture)
            _eventDescription = State(initialValue: event.EventDescription)
        }
    
    

    var body: some View {
        ScrollView{
            VStack {
                Text("Rediger Event")
                    .font(.headline)
                VStack(alignment: .leading, spacing: 8) {
                    Text("\(eventTitle)")
                        .font(.headline)
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.gray)
                        Picker("Vælg træningstype", selection: $eventTitle) {
                            ForEach(availableTypes, id: \.self) { type in
                                Text(type)
                                    .tag(type)  // hver option får en tag der matcher værdien
                            }
                        }
                        .pickerStyle(.menu)
                        .tint(.white)
                    }
                    .shadow(radius: 5)
                    Image("\(eventTitle)")
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
                        Picker("", selection: $eventDuration){
                            ForEach(availableDurations, id: \.self){ time in
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
                            Picker("", selection: $eventTrainer ){
                                ForEach(availableTrainers, id: \.self) { TName in
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
                            Picker("", selection: $eventSlots ){
                                ForEach(availableSlots, id: \.self) { amount in
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
                    TextField("Indtast lokation", text: $eventLocation)
                        .textFieldStyle(UnderlinedTextFieldStyle())
                    
                    HStack{
                        Label("Vælg dato", systemImage: "calendar")
                            .font(.headline)
                        DatePicker("", selection: $eventDate)
                            .datePickerStyle(.compact)
                    }
                    Label("Beskrivelse", systemImage: "text.alignleft")
                        .font(.headline)
                    TextEditor(text: $eventDescription)
                        .outlinedTextEditorStyle()
                        .frame(height: 100)
                    ZStack{
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.gray)
                            .frame(height: 50)
                        Button("Rediger Eventet"){
                            let updatedEvent = EventModel(
                                id: event.id,
                                EventTitle: eventTitle,
                                EventDuration: eventDuration,
                                EventTrainer: eventTrainer,
                                EventLocation: eventLocation,
                                EventMemembers: event.EventMemembers,
                                EventSlots: eventSlots,
                                EventDate: eventDate,
                                EventPicture: eventPicture,
                                EventDescription: eventDescription
                            )
                            viewModel.updateEvent(updatedEvent)
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
