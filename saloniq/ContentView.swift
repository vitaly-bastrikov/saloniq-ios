//
//  ContentView.swift
//  saloni
//
//  Created by Vitaly Bastrikov on 2024-01-16.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }

            OrderView()
                .tabItem {
                    Label("Cart", systemImage: "cart")
                }
            
            AccountView()
                .tabItem {
                    Label("Account", systemImage: "person")
                }
        }
        .accentColor(.black)
    }
}

#Preview {
    ContentView()
}


