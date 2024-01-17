//
//  OrderView.swift
//  saloniq
//
//  Created by Vitaly Bastrikov on 2024-01-16.
//

import SwiftUI

struct OrderView: View {
    
    @EnvironmentObject var order: Order
    @State var total: Int = 0
    
    var body: some View {
        VStack (alignment: .leading) {
            Text("MY CART")
                .font(.system(size: 20, weight: .light))
                .foregroundColor(.darkGray)
                .padding()
            
            // card products
            if order.products.count > 0 {
                ScrollView(showsIndicators: false) {
                    VStack() {
                        ForEach(order.products) { product in
                            OrderItemView(product: product)
                        }
                    }
                }
                Spacer()
                
                // total
                HStack () {
                    Spacer()
                    Text("TOTAL")
                        .font(.system(size: 14, weight: .light))
                        .foregroundColor(.darkGray)
                    //                Spacer()
                    Text("$\(order.total, specifier: "%.2f")")
                        .font(.system(size: 14))
                        .foregroundColor(.darkGray)
                    Spacer()
                }.padding()
                
                //            Spacer()
                
                // Place your order
                HStack {
                    Spacer()
                    Button("PLACE YOUR ORDER") {
                        print("ORDER PLACED")
                    }
                    .foregroundColor(.white)
                    .font(.system(size: 12, weight: .light))
                    .padding(10)
                    .background(Color(UIColor.darkGray))
                    Spacer()
                }
            } else {
                EmptyCartView()
            }
            
            
            
            
        }
        .padding(20)
    }
}

struct OrderView_Previews: PreviewProvider {
    static var previews: some View {
        let order = Order()
        order.products = Array(mockProducts.prefix(upTo: 3))
        order.products = []
        // any more parameters set up here
        
        return OrderView().environmentObject(order)
    }
}

struct OrderItemView: View {
    
    @EnvironmentObject var order: Order
    var product: Product
    
    var body: some View {
        HStack{
            AsyncImage(url: URL(string: product.imageURL)) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 100, height: 100)
            
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text("\(product.title)")
                        .font(.system(size: 12, weight: .light))
                        .foregroundColor(.darkGray)
                    Text("$\(product.price)")
                        .foregroundColor(.darkGray)
                        .font(.system(size: 12, weight: .light))
                }
                .fixedSize(horizontal: false, vertical: true)
                
                Spacer(minLength: 20)
                
                Button {
                    order.products = order.products.filter { $0.id != product.id }
                } label: {
                    Image(systemName: "x.circle").accentColor(.lightBlack)
                    
                }
            }
            .padding()
            
        }
        .padding()
    }
}

struct EmptyCartView: View {
    var body: some View {
        Spacer()
        VStack {
            Image(.emptyCart)
                .resizable()
                .scaledToFit()
                .frame(width: 100)
            Text("YOUR CART IS EMPTY")
                .font(.system(size: 14, weight: .light))
                .foregroundColor(.darkGray)
        }
        
        Spacer()
    }
}
