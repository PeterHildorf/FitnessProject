//
//  InstructorView.swift
//  FitnessProject
//
//  Created by Wame Gassama on 20/04/2025.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
           if let user = viewModel.currentUser {
               ZStack {
                   Color.gray.opacity(0.2)
                       .ignoresSafeArea(edges: .top)

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
                       .foregroundColor(.black)

                       Section("Account") {
                           Button {
                               viewModel.signOut()
                           } label: {
                               SettingsRowView(imageName: "rectangle.portrait.and.arrow.right",
                                               title: "Sign Out",
                                               tintColor: .red)
                           }
                       }
                       .foregroundColor(.black)
                   }
                   .scrollContentBackground(.hidden)
                   // Only removes the built-in background of the LIST scrollview.
                   // So that our Color.gray.opacity(0.2) from the ZStack can shine through the sections.
               }
           }
       }
   }
