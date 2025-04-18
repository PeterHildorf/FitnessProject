//
//  FitnessProjectApp.swift
//  FitnessProject
//
//  Created by Peter Hannibal Hildorf on 01/04/2025.
//

import SwiftUI

@main
struct FitnessProjectApp: App {
    let persistenceController = PersistenceController.shared

    @StateObject var dataVM = DataViewModel()

    var body: some Scene {
        WindowGroup {
            //EventCreateView()
            BookingListView(viewModel: ListViewModel(data: dataVM, year: Calendar.current.component(.year, from: Date())))
            //ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
