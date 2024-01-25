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
            ShopView()
                .tabItem {
                    Label("Products", systemImage: "house")
                }

            CartView()
                .tabItem {
                    Label("Cart", systemImage: "cart")
                }
            
//            AccountView()
//                .tabItem {
//                    Label("Account", systemImage: "person")
//                }
        }
        .accentColor(.black)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let order = Order()
        order.orderItems = Array(mockOrderItems.prefix(upTo: 3))
        return ContentView().environmentObject(order)
    }
}


