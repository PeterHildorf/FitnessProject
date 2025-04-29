//
//  FitnessProjectApp.swift
//  FitnessProject
//
//  Created by Peter Hannibal Hildorf on 01/04/2025.
//

import SwiftUI
import Firebase
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseAppCheck

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        let providerFactory = AppCheckDebugProviderFactory()
        AppCheck.setAppCheckProviderFactory(providerFactory)
        
        FirebaseApp.configure()
        /*
        var settings = Firestore.firestore().settings
    
        // Anvender offline cache via cache settings
        
        settings.cacheSettings = PersistentCacheSettings(
            // FirestoreCacheSizeUnlimited er en NSNumber-konstant, der deaktiverer automatisk oprydning
            sizeBytes: NSNumber(value: FirestoreCacheSizeUnlimited)
        )
        
        
        Firestore.firestore().settings = settings
         */
        
        return true
    }
}

@main
struct FitnessProjectApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    let persistenceController = PersistenceController.shared
    
    @StateObject var AuthVM = AuthViewModel()
    @StateObject var eventDataVM = EventDataViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(AuthVM)
                .environmentObject(eventDataVM)
        }
    }
}
