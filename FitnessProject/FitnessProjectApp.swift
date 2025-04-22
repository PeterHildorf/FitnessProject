//
//  FitnessProjectApp.swift
//  FitnessProject
//
//  Created by Peter Hannibal Hildorf on 01/04/2025.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseAppCheck

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        let providerFactory = AppCheckDebugProviderFactory()
        AppCheck.setAppCheckProviderFactory(providerFactory)
        
        FirebaseApp.configure()
        
        return true
    }
}

@main
struct FitnessProjectApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    let persistenceController = PersistenceController.shared
    
    @StateObject var AuthVM = AuthViewModel()
    @StateObject var dataVM = DataViewModel()

    var body: some Scene {
        WindowGroup {
            //EventCreateView()
            BookingListView(viewModel: ListViewModel(data: dataVM, year: Calendar.current.component(.year, from: Date())))
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(AuthVM)
        }
    }
}
