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
                   // Blå baggrund bag listen – men kun top safe area
                   Color.blue
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
                       .foregroundColor(.white)

                       Section("Account") {
                           Button {
                               viewModel.signOut()
                           } label: {
                               SettingsRowView(imageName: "rectangle.portrait.and.arrow.right",
                                               title: "Sign Out",
                                               tintColor: .red)
                           }
                       }
                       .foregroundColor(.white)
                   }
                   .scrollContentBackground(.hidden)
                   // fjerner kun den indbyggede baggrund for LIST-scrollview'en,
                   // så vores Color.blue fra ZStack kan skinne igennem sektionerne
               }
           }
       }
   }
