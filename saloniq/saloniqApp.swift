//
//  saloniApp.swift
//  saloni
//
//  Created by Vitaly Bastrikov on 2024-01-16.
//

import SwiftUI
import Stripe


@main
struct saloniApp: App {
    
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
