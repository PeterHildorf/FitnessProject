import SwiftUI

/// Genbrugelig form til både oprettelse og redigering.
/// Du binder direkte dine @State‑felter ind med Binding.
struct EventFormView: View {
    @EnvironmentObject var eventVM: EventDataViewModel
    @EnvironmentObject var authVM: AuthViewModel
    
    @Binding var title: String
    @Binding var duration: Int
    @Binding var selectedTrainer: User?
    @Binding var location: String
    @Binding var slots: Int
    @Binding var date: Date
    @Binding var description: String
    
    let types       = ["Fitness","Run","Yoga"]
    let durations   = [30,60,90,180]
    let slotOptions = [5,10,15,20,25]
    
    let buttonTitle: String
    let buttonAction: () -> Void
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // 1) Title
                Text("Event Title").font(.headline)
                Picker("", selection: $title) {
                    ForEach(types, id: \.self) { Text($0).tag($0) }
                }
                .pickerStyle(.menu)
                Image(title)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10)
                
                // 2) Duration
                Text("Varighed").font(.headline)
                Picker("", selection: $duration) {
                    ForEach(durations, id: \.self) { Text("\($0) min").tag($0) }
                }
                .pickerStyle(.menu)
                
                // 3) Instruktør
                Text("Instruktør").font(.headline)
                
                if selectedTrainer != nil {
                    Picker("Vælg instruktør", selection: $selectedTrainer) {
                        ForEach(eventVM.instructors) { instr in
                            Text(instr.fullname).tag(Optional(instr))
                        }
                    }
                    .pickerStyle(.menu)
                } else {
                    Text("No selections available")
                        .foregroundColor(.red)
                }
                
                // 4) Pladser
                Text("Pladser").font(.headline)
                Picker("", selection: $slots) {
                    ForEach(slotOptions, id: \.self) { Text("\($0)").tag($0) }
                }
                .pickerStyle(.segmented)
                
                // 5) Lokation
                Text("Lokation").font(.headline)
                TextField("Indtast lokation", text: $location)
                    .textFieldStyle(UnderlinedTextFieldStyle())
                
                // 6) Dato & tid
                Text("Dato & tid").font(.headline)
                DatePicker("", selection: $date)
                    .datePickerStyle(.compact)
                
                // 7) Beskrivelse
                Text("Beskrivelse").font(.headline)
                TextEditor(text: $description)
                    .outlinedTextEditorStyle()
                    .frame(height: 100)
                
                // 8) Knap
                Button(buttonTitle, action: buttonAction)
                    .frame(maxWidth: .infinity, minHeight: 44)
                    .background(Color.blue.cornerRadius(8))
                    .foregroundColor(.white)
            }
            .padding()
        }
        // Lyt på instructors-publisheren, ikke .onAppear
        .onReceive(eventVM.$instructors) { instructors in
            guard selectedTrainer == nil,
                  !instructors.isEmpty,
                  let uid = authVM.currentUser?.id,
                  let me = instructors.first(where: { $0.id == uid })
            else { return }
            selectedTrainer = me
        }
        
    }
}



// Håndter underlinet textfield style
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

// Håndter outline style for TextEditor
struct OutlinedTextEditorStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color(UIColor.systemGray4), lineWidth: 1)
            )
    }
}

// Extension for nem brug af OutlinedTextEditorStyle
extension View {
    func outlinedTextEditorStyle() -> some View {
        self.modifier(OutlinedTextEditorStyle())
    }
}


