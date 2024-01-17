//
//  AccountView.swift
//  saloniq
//
//  Created by Vitaly Bastrikov on 2024-01-16.
//

import SwiftUI

struct AccountView: View {
    var body: some View {
        Text("Account")
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        let order = Order()
        order.products = Array(mockProducts.prefix(upTo: 3))
        // any more parameters set up here

        return AccountView().environmentObject(order)
    }
}
