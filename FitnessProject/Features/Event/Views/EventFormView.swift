import SwiftUI

/// Genbrugelig form til både oprettelse og redigering.
/// Du binder direkte dine @State‑felter ind med Binding.
struct EventFormView: View {
    // Bindings som taler med parent‑viewets @State-variabler
    @Binding var title: String
    @Binding var duration: Int
    @Binding var trainer: String
    @Binding var location: String
    @Binding var slots: Int
    @Binding var date: Date
    @Binding var description: String
    
    // Fælles konfigurationsdata
    let types       = ["Fitness","Run","Yoga"]
    let durations   = [30,60,90,180]
    let trainers    = ["Peter Hildorf","Victor Mandrup","Mathias Larsen"]
    let slotOptions = [5,10,15,20,25]
    
    // Label & action for knappen
    let buttonTitle: String
    let buttonAction: () -> Void
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Træningstype
                Text("Event Title").font(.headline)
                Picker("", selection: $title) {
                    ForEach(types, id: \.self) { Text($0).tag($0) }
                }
                .pickerStyle(.menu)
                Image(title)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10)

                // Varighed
                Text("Varighed").font(.headline)
                Picker("", selection: $duration) {
                    ForEach(durations, id:\.self) {
                        Text("\($0) min").tag($0)
                    }
                }
                .pickerStyle(.menu)

                // Instruktør
                Text("Instruktør").font(.headline)
                Picker("", selection: $trainer) {
                    ForEach(trainers, id:\.self) { Text($0).tag($0) }
                }
                .pickerStyle(.menu)

                // Antal pladser
                Text("Pladser").font(.headline)
                Picker("", selection: $slots) {
                    ForEach(slotOptions, id:\.self) { Text("\($0)").tag($0) }
                }
                .pickerStyle(.segmented)

                // Lokation
                Text("Lokation").font(.headline)
                TextField("Indtast lokation", text: $location)
                    .textFieldStyle(UnderlinedTextFieldStyle())

                // Dato
                Text("Dato & tid").font(.headline)
                DatePicker("", selection: $date)
                    .datePickerStyle(.compact)

                // Beskrivelse
                Text("Beskrivelse").font(.headline)
                TextEditor(text: $description)
                    .outlinedTextEditorStyle()
                    .frame(height: 100)
                
                // Gem/Opdater‑knap
                Button(buttonTitle, action: buttonAction)
                    .frame(maxWidth: .infinity, minHeight: 44)
                    .background(Color.blue.cornerRadius(8))
                    .foregroundColor(.white)
            }
            .padding()
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
