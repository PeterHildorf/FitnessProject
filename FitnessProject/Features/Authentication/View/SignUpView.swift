//
//  SignUpView.swift
//  FitnessProject
//
//  Created by Wame Gassama on 01/04/2025.
//

import SwiftUI

struct SignUpView: View {
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
   
    // AuthViewModel is initialized ones in the content view
    @EnvironmentObject private var viewModel: AuthViewModel
    
    
    @FocusState private var isEmailFocused: Bool
    @FocusState private var isPasswordFocused: Bool
    @FocusState private var isFullnameFocused: Bool
    
    @State private var showEmailValidation = false
    @State private var showPasswordValidation = false
    @State private var showFullnameValidation = false
    @State private var email = ""
    @State private var password = ""
    @State private var role = "Member"
    @State private var fullname = ""
    
    
    var body: some View {
        VStack {
            Text("Register")
                .font(.system(size: 36, weight: .bold, design: .rounded))
                .foregroundColor(.black.opacity(0.95))
            VStack(spacing: 20) {
                VStack(spacing: 5) {
                    TextField("Fullname", text: $fullname)
                        .focused($isFullnameFocused)
                        .padding(.vertical, 20)
                        .padding(.horizontal, 20)
                        .background(.white)
                        .clipShape(.rect(cornerRadius: 10))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(showFullnameValidation ? Color.red : isFullnameFocused ? Color.blue : Color.clear, lineWidth: 2) // Rounded border
                        )
                        .onChange(of: isFullnameFocused) { oldValue, newValue in
                            // When focus is lost, validate
                            if !newValue {
                                showFullnameValidation = fullname.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                            }
                        }
                    
                    if showFullnameValidation {
                        HStack(spacing: 5) {
                            Image(systemName: "exclamationmark.circle.fill").foregroundStyle(.red)
                            Text("Fullname is required")
                                .foregroundColor(.red)
                                .font(.caption)
                                .transition(.opacity)
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                        .padding(0)
                    }
                }
                VStack(spacing: 5) {
                    TextField("Email Address", text: $email)
                        .focused($isEmailFocused)
                        .padding(.vertical, 20)
                        .padding(.horizontal, 20)
                        .background(.white)
                        .clipShape(.rect(cornerRadius: 10))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(showEmailValidation ? Color.red : isEmailFocused ? Color.blue : Color.clear, lineWidth: 2) // Rounded border
                        )
                        .onChange(of: isEmailFocused) { oldValue, newValue in
                                // When focus is lost, validate
                                if !newValue {
                                    showEmailValidation = email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                                }
                            }
                    
                    if showEmailValidation {
                        HStack(spacing: 5) {
                            Image(systemName: "exclamationmark.circle.fill").foregroundStyle(.red)
                            Text("Valid email address required")
                                .foregroundColor(.red)
                                .font(.caption)
                                .transition(.opacity)
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                        .padding(0)
                    }
                }
                VStack(spacing: 5) {
                    SecureField("Password", text: $password)
                        .focused($isPasswordFocused)
                        .padding(.vertical, 20)
                        .padding(.horizontal, 20)
                        .background(.white)
                        .clipShape(.rect(cornerRadius: 10))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(showPasswordValidation ? Color.red : isPasswordFocused ? Color.blue : Color.clear, lineWidth: 2)
                        )
                        .onChange(of: isPasswordFocused) { oldValue, newValue in
                                if !newValue {
                                    showPasswordValidation = password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                                }
                            }
                    
                    if showPasswordValidation {
                        HStack(spacing: 5) {
                            Image(systemName: "exclamationmark.circle.fill").foregroundStyle(.red)
                            Text("Password required (min 6 characters)")
                                .foregroundColor(.red)
                                .font(.caption)
                                .transition(.opacity)
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                        .padding(0)
                    }
                }
                
                HStack {
                    if(role == "Member") {
                        Text("Join as a")
                    } else {
                        Text("Join as an")
                    }
                    Spacer()
                    Menu(role) {
                        Button("Member") {
                            role = "Member"
                        }
                        Button("Instructor") {
                            role = "Instructor"
                        }
                    } 
                }
                .padding(.horizontal)
                .padding(.vertical, 20)
                .background(.white)
                .clipShape(.rect(cornerRadius: 20))
                Button{
                    Task {
                        try await viewModel.createNewUser(email, password, role, fullname)
                    }
                } label: {
                    HStack {
                        Text("Sign Up").foregroundColor(Color.white).font(.system(size: 18, weight: .bold, design: .rounded)).frame(maxWidth: .infinity)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                    .background(Color.blue)
                    .clipShape(.rect(cornerRadius: 20))
                }
            }
            .alert(isPresented: $viewModel.hasError, error: viewModel.error) { error in
                
            } message: { error in
                Text(error.failureReason!)
            }


        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .navigationBarBackButtonHidden()
        .background(Color.gray.opacity(0.2) as Color)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "arrow.left").foregroundStyle(.blue)
                }
            }
        }
    }
}

#Preview {
    SignUpView()
}
