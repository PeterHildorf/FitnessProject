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
        // 🔥 40 MB er default – her sætter vi 100 MB
        let settings = Firestore.firestore().settings
        let bytes = 100 * 1024 * 1024          // Int
        settings.cacheSettings = PersistentCacheSettings(
            sizeBytes: NSNumber(value: bytes)  // ← wrap som NSNumber
        )
        Firestore.firestore().settings = settings
        
        return true
    }
}

@main
struct FitnessProjectApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    
    @StateObject var AuthVM = AuthViewModel()
    
    var body: some Scene {
        WindowGroup {
            if let uid = AuthVM.userSession?.uid {      // -------- Login-gren
                ContentView()
                    .environmentObject(AuthVM)          // 2) Auth ned til alle
                    .environmentObject(                 // 3) NY EventDataVM pr. uid
                        EventDataViewModel(
                            service: GuardedEventService(
                                rolePublisher: AuthVM.$currentRole
                            )
                        )
                    )
                    .id(uid)                            // 4) tving re-build
            } else {                                    // -------- Logout-gren
                GetStartedView()
                    .environmentObject(AuthVM)
            }
        }
    }
}
