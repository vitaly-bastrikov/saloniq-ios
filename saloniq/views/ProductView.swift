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
        VStack(spacing: 30) {
            VStack {
                AsyncImage(url: URL(string: product.imageURL)) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200)
                    
                } placeholder: {
                    ProgressView()
                }
                Text("\(product.title)")
                    .font(.system(size: 16, weight: .light))
                    .foregroundColor(.darkGray)
            }.frame(maxWidth: .infinity)
            
            
            VStack(alignment: .leading, spacing: 10) {
                Text("DESCRIPTION")
                    .foregroundColor(.darkGray)
                    .font(.system(size: 14, weight: .light))
                
                Text(product.description)
                    .foregroundColor(.darkGray)
                    .font(.system(size: 12, weight: .light))
            }
            
            VStack(alignment: .leading, spacing: 10) {
                Text("PRODUCT DETAILS")
                    .foregroundColor(.darkGray)
                    .font(.system(size: 14, weight: .light))
                
                HStack {
                    Text("MATERIAL")
                        .foregroundColor(.darkGray)
                        .font(.system(size: 12, weight: .light))
                    Spacer()
                    Text("Metal")
                        .foregroundColor(.darkGray)
                        .font(.system(size: 12, weight: .light))
                }
                
                HStack {
                    Text("SIZE")
                        .foregroundColor(.darkGray)
                        .font(.system(size: 12, weight: .light))
                    Spacer()
                    Text("XS")
                        .foregroundColor(.darkGray)
                        .font(.system(size: 12, weight: .light))
                }
                
                HStack {
                    Text("WEIGHT")
                        .foregroundColor(.darkGray)
                        .font(.system(size: 12, weight: .light))
                    Spacer()
                    Text("0.6kg")
                        .foregroundColor(.darkGray)
                        .font(.system(size: 12, weight: .light))
                }
            }
                
            
            Spacer()
            Text("$\(product.price, specifier: "%.2f")")
                .foregroundColor(.darkGray)
                .font(.system(size: 14, weight: .light))
                
            
            
            Button("ADD TO CART") {
                order.addToCart(product: product)

                dismiss()
            }
            .foregroundColor(.white)
            .font(.system(size: 12, weight: .light))
            .padding(7)
            .background(Color(UIColor.black))
            
            
        }
        .padding(20)
    }
}

struct ProductView_Previews: PreviewProvider {
    
    
    static var previews: some View {
        let product = mockProducts[0]
        let order = Order()
        order.orderItems = Array(mockOrderItems.prefix(upTo: 3))
        
        return ProductView(product: product).environmentObject(order)
    }
}

