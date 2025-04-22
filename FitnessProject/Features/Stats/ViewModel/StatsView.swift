//
//  StatsView.swift
//  FitnessProject
//
//  Created by Peter Hannibal Hildorf on 22/04/2025.
//

import SwiftUI


struct StatsView: View {
    var body: some View {
        ScrollView {
            HStack(spacing: -65){
                Spacer()
                Text("user.name")
                    .bold()
                Spacer()
                Button(){
                    print("Trykket")
                } label: {
                    Label("Profil", systemImage: "person.circle")

                }
            }
            .padding()
        }
    }
}

struct StatsView_Preview: PreviewProvider {
    static var previews: some View {
        StatsView()
    }
}
