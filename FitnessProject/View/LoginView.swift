//
//  LoginView.swift
//  FitnessProject
//
//  Created by Wame Gassama on 01/04/2025.
//

import SwiftUI

struct LoginView: View {
    var body: some View {
        VStack(spacing: 70) {
            Image("authentication")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: 300, maxHeight: 300)
                .padding(.top, 100)
            VStack(spacing: 20) {
                Button {
                    
                } label: {
                    HStack {
                        Text("Get started").foregroundColor(Color.white).font(.system(size: 18, weight: .bold, design: .rounded)).frame(maxWidth: .infinity)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                    .background(Color.blue)
                    .clipShape(.rect(cornerRadius: 20))
                }
                Button {
                    
                } label: {
                    HStack {
                        Text("Login").foregroundColor(Color.blue).font(.system(size: 18, weight: .bold, design: .rounded))
                            .frame(maxWidth: .infinity)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                    .background(Color.white)
                    .clipShape(.rect(cornerRadius: 20))
                }
                HStack {
                    Text("New around here?")
                    Button {
                        
                    } label: {
                        Text("Sign up")
                    }
                }
                .padding(.top, 20)
                .font(.system(size: 16, weight: .light, design: .rounded))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .background(.gray.opacity(0.2))
        
    }
}

#Preview {
    LoginView()
}
