//
//  SignInView.swift
//  FitnessProject
//
//  Created by Wame Gassama on 19/04/2025.
//

import SwiftUI

struct SignInView: View {
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    
    // AuthViewModel is initialized ones in the content view
    @EnvironmentObject private var viewModel: AuthViewModel
    
    @FocusState private var isEmailFocused: Bool
    @FocusState private var isPasswordFocused: Bool
    
    @State private var email: String = ""
    @State private var password: String = ""
    
    
    var body: some View {
        VStack {
            Text("Sign In")
                .font(.system(size: 36, weight: .bold, design: .rounded))
                .foregroundColor(.black.opacity(0.95))
            VStack(spacing: 20) {
                TextField("Email Address", text: $email)
                    .focused($isEmailFocused)
                    .padding(.vertical, 20)
                    .padding(.horizontal, 20)
                    .background(.white)
                    .clipShape(.rect(cornerRadius: 10))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(isEmailFocused ? Color.blue : Color.clear, lineWidth: 2)
                    )
                SecureField("Password", text: $password)
                    .focused($isPasswordFocused)
                    .padding(.vertical, 20)
                    .padding(.horizontal, 20)
                    .background(.white)
                    .clipShape(.rect(cornerRadius: 10))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(isPasswordFocused ? Color.blue : Color.clear, lineWidth: 2)
                    )
                Button{
                    Task {
                        try await viewModel.signIn(email, password)
                    }

                } label: {
                    HStack {
                        Text("Sign In").foregroundColor(Color.white).font(.system(size: 18, weight: .bold, design: .rounded)).frame(maxWidth: .infinity)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                    .background(Color.blue)
                    .clipShape(.rect(cornerRadius: 20))
                }
            }
            .alert(isPresented: $viewModel.hasError, error: viewModel.error) { error in
                Text("Try again")
            } message: { error in
                Text(error.failureReason!)
            }


        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .background(Color.gray.opacity(0.2) as Color)
        .navigationBarBackButtonHidden()
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
    SignInView()
}
