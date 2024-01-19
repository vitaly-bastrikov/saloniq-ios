//
//  OrderView.swift
//  saloniq
//
//  Created by Vitaly Bastrikov on 2024-01-16.
//

import SwiftUI
import PassKit

struct CartView: View {
    
    @EnvironmentObject var order: Order
    @State var total: Int = 0
    @State private var isLoading = false
    
    let paymentHandler = PaymentHandler()
    
    var applePayButton: some View {
        
        HStack {
            Spacer()
            PayWithApplePayButton {
                print("Trying to Pay with Apple")
                isLoading = false
                var paymentSummaryItems = [PKPaymentSummaryItem]()
                order.products.forEach { product in
                    paymentSummaryItems.append(PKPaymentSummaryItem(
                        label: product.title,
                        amount: NSDecimalNumber(string: product.price),
                        type: .final)
                    )
                }
                paymentSummaryItems.append(PKPaymentSummaryItem(
                    label: "Total",
                    amount: NSDecimalNumber(string: String(order.total)),
                    type: .final)
                )
                
                self.paymentHandler.startPayment(items: paymentSummaryItems) { ok, paymentJson in
                    if ok {
                        print("success")
                    } else {
                        print("failure")
                    }
                    self.isLoading = false
                }
            }
            .scaledToFit()
            .frame(width: 150)
            Spacer()
        }
        
    }
    
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
                
                
                
                
                if !self.isLoading {
                    if PKPaymentAuthorizationController.canMakePayments() {
                        applePayButton
                    } else {
                        Text("Cannot pay with Apple")
                    }
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
        //        order.products = []
        // any more parameters set up here
        
        return CartView().environmentObject(order)
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


