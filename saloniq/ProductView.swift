//
//  ProductView.swift
//  saloniq
//
//  Created by Vitaly Bastrikov on 2024-01-18.
//

import SwiftUI

struct ProductView: View {
    @EnvironmentObject var order: Order
    @Environment(\.dismiss) private var dismiss
    
    let product: Product
    
    var body: some View {
        VStack {
            Text("\(product.title)")
                .font(.system(size: 16, weight: .light))
                .foregroundColor(.darkGray)
            
            Spacer()
            
            AsyncImage(url: URL(string: product.imageURL)) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .scaledToFit()
            .frame(width: 200)
            
            Text(product.description)
                .foregroundColor(.darkGray)
                .font(.system(size: 12, weight: .light))
                .padding()
            
            Spacer()
            Text("$\(product.price)")
                .foregroundColor(.darkGray)
                .font(.system(size: 14, weight: .light))
                .padding()
            
            
            Button("ADD TO CART") {
                order.products.append(product)
                dismiss()
            }
            .foregroundColor(.white)
            .font(.system(size: 12, weight: .light))
            .padding(7)
            .background(Color(UIColor.darkGray))
            
            
        }
        .padding(20)
    }
}

struct ProductView_Previews: PreviewProvider {
    
    
    static var previews: some View {
        let product = mockProducts[0]
        
        let order = Order()
        order.products = Array(mockProducts.prefix(upTo: 3))
        order.products = []
        // any more parameters set up here
        
        return ProductView(product: product).environmentObject(order)
    }
}

