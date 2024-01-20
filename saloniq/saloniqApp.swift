//
//  saloniApp.swift
//  saloni
//
//  Created by Vitaly Bastrikov on 2024-01-16.
//

import SwiftUI
import Stripe
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}


@main
struct saloniApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    init() {
        StripeAPI.defaultPublishableKey = "pk_test_5cBKxGzB74aF4rOZsNfIGmO600bkAPncZC"
    }
    
    @StateObject var order = Order()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .environmentObject(order)
    }

}
