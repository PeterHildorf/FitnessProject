//
//  Untitled.swift
//  FitnessProject
//
//  Created by Peter Hannibal Hildorf on 04/05/2025.
//

// ProfileTemplateView.swift
import SwiftUI

// Sørg for at have din User-model tilgængelig her:
struct DummyUser {
    let initials: String
    let fullname: String
    let email: String
    let role: Role
    
    enum Role: String {
        case member, instructor
    }
}

struct ProfileTemplateView: View {
    // Dummy‑data til preview
    private let user = DummyUser(
        initials: "WG",
        fullname: "Wame Gassama",
        email: "wame@example.com",
        role: .member
    )
    
    var body: some View {
        List {
            Section {
                HStack {
                    Text(user.initials)
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(width: 72, height: 72)
                        .background(Color(.systemGray3))
                        .clipShape(Circle())
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(user.fullname)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .padding(.top, 4)
                        
                        Text(user.email)
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
                }
            }
            
            Section("General") {
                HStack {
                    SettingsRowView(imageName: "person.fill", title: "Role", tintColor: .gray)
                    Spacer()
                    Text(user.role.rawValue.capitalized)
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(user.role == .member ? Color.blue : Color.green)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
            .foregroundColor(.white)
            
            Section("Account") {
                // Dummy‑knap uden funktion
                Button(action: {}) {
                    SettingsRowView(
                        imageName: "rectangle.portrait.and.arrow.right",
                        title: "Sign Out",
                        tintColor: .red
                    )
                }
                .disabled(true) // markér som ikke‑funktionel
            }
            .foregroundColor(.white)

        }
        .listStyle(InsetGroupedListStyle())
        .scrollContentBackground(.hidden)
        .background(Color.blue)
    }
}

// Preview‑folder (f.eks. PreviewContent/ProfileTemplateView.swift)
struct ProfileTemplateView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ProfileTemplateView()
                .previewDisplayName("Light Mode")
            
            ProfileTemplateView()
                .preferredColorScheme(.dark)
                .previewDisplayName("Dark Mode")
        }
    }
}
