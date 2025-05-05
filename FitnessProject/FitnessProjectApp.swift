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

        let settings = Firestore.firestore().settings
        let bytes = 100 * 1024 * 1024          //40MB cache size
        settings.cacheSettings = PersistentCacheSettings(
            sizeBytes: NSNumber(value: bytes)
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
            if let uid = AuthVM.userSession?.uid {
                ContentView()
                    .environmentObject(AuthVM)          // injecting authVM
                    .environmentObject(                 // everytime we logout we make sure the eventdataViewmodel is updated
                        EventDataViewModel(
                            service: GuardedEventService(
                                rolePublisher: AuthVM.$currentRole
                            )
                        )
                    )
                    .id(uid)
            } else {
                GetStartedView()
                    .environmentObject(AuthVM)
            }
        }
    }
}
