//
//  saloniApp.swift
//  saloni
//
//  Created by Vitaly Bastrikov on 2024-01-16.
//

import SwiftUI

@main
struct saloniApp: App {
    
    @StateObject var order = Order()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .environmentObject(order)
    }

}
