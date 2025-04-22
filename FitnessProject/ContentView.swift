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
    @StateObject var dataVM = DataViewModel()

    var body: some View {
        if AuthVM.userSession != nil {
            BookingListView(viewModel: ListViewModel(data: dataVM, year: Calendar.current.component(.year, from: Date())))
        } else {
            GetStartedView()
        }
    }
}


#Preview {
    ContentView()
}
