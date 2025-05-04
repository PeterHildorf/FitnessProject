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
    
    private var isFormValid: Bool {
        !location.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // 1) Title
                Text("Event Title").font(.headline)
                Picker("", selection: $title) {
                    ForEach(types, id: \.self) { Text($0).tag($0) }
                }
                .pickerStyle(.menu)
                .frame(maxWidth: .infinity, minHeight: 50)         // fylder bredt og har minimumshøjde
                .padding(.horizontal, 16)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(.blue))                 // lys grå baggrund
                )
                .tint(.white)
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
                .frame(maxWidth: .infinity, minHeight: 50)
                .padding(.horizontal, 16)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(.blue))
                )
                .tint(.white)
                // 3) Instruktør
                Text("Instruktør").font(.headline)
                
                if selectedTrainer != nil {
                    Picker("Vælg instruktør", selection: $selectedTrainer) {
                        ForEach(eventVM.instructors) { instr in
                            Text(instr.fullname).tag(Optional(instr))
                        }
                    }
                    .pickerStyle(.menu)
                    .frame(maxWidth: .infinity, minHeight: 50)         // fylder bredt og har minimumshøjde
                    .padding(.horizontal, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(.blue))                 // lys grå baggrund
                    )
                    .tint(.white)
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
                    .textFieldStyle(UnderlinedTextFieldStyle(lineColor: isFormValid ? .blue : .red))
                    .padding(.vertical, 2)
                    
                // 6) Dato & tid
                Text("Dato & tid").font(.headline)
                DatePicker("",
                           selection: $date,
                           in: Date()...,
                           displayedComponents: [.date, .hourAndMinute]
                )
                .datePickerStyle(.compact)
                
                // 7) Beskrivelse
                Text("Beskrivelse").font(.headline)
                TextEditor(text: $description)
                    .outlinedTextEditorStyle()
                    .frame(height: 100)
                
                // 8) Knap
                Button(buttonTitle, action: buttonAction)
                    .disabled(!isFormValid)
                    .frame(maxWidth: .infinity, minHeight: 44)
                    .background(
                        (isFormValid ? Color.blue : Color.red)
                        .cornerRadius(8)
                        )
                    .foregroundColor(.white)
                
                if !isFormValid {
                    Text("Lokation er påkrævet for at oprette/redigere et event.")
                        .font(.footnote)
                        .foregroundColor(.red)
                }
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
    var lineColor: Color  // nu kan vi selv vælge farven

    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(.vertical, 8)
            .background(
                VStack {
                    Spacer()
                    lineColor
                        .frame(height: 2)
                }
            )
    }
}


// Håndter outline style for TextEditor
struct OutlinedTextEditorStyle: ViewModifier {
    var lineColor: Color
    func body(content: Content) -> some View {
        content
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(lineColor, lineWidth: 1)
            )
    }
}

// Extension for nem brug af OutlinedTextEditorStyle
extension View {
    func outlinedTextEditorStyle(lineColor: Color = .blue) -> some View {
        self.modifier(OutlinedTextEditorStyle(lineColor: lineColor))
    }
}


