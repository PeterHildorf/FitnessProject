//
//  ContentView.swift
//  FitnessProject
//
//  Created by Peter Hannibal Hildorf on 01/04/2025.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @EnvironmentObject var AuthVM: AuthViewModel
    @EnvironmentObject var eventDataVM: EventDataViewModel

    @State private var valgteTab: Tab = .booking
    
    enum Tab {
            case booking, profil
        }
    
    var body: some View {
        if AuthVM.userSession != nil {
            TabView(selection: $valgteTab) {
                NavigationStack {
                    //booking
                    BookingListView(viewModel: ListViewModel(
                        data: eventDataVM,
                        year: Calendar.current.component(.year, from: Date())))
                    .navigationTitle("")
                }
                .tabItem {
                    Label("Booking", systemImage: "calendar")
                }
                .tag(Tab.booking)
                
                //Profile
                NavigationStack {
                    ProfileView()
                        .navigationTitle("")
                }
                .tabItem {
                    Label("Profil", systemImage: "person.crop.circle")
                }
                .tag(Tab.profil)

            }
            
        } else {
            GetStartedView()
        }
    }
}


#Preview {
    ContentView()
}
