//
//  OrderView.swift
//  saloniq
//
//  Created by Vitaly Bastrikov on 2024-01-16.
//

import SwiftUI
import PassKit
import Stripe

struct CartView: View {
    
    @EnvironmentObject var order: Order
    @State var total: Int = 0
    @State var isActive = false
    
    
    private func startCheckout(completion: @escaping (String?) -> Void) {
        let url = URL(string: "https://us-central1-saloniq-f4fd8.cloudfunctions.net/app/create-payment-intent")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(order.total)
        
        URLSession.shared.dataTask(with: request) {data, response, error in
            
            guard let data = data, error == nil,
                  (response as? HTTPURLResponse)?.statusCode == 200
            else {
                completion(nil)
                return
            }
            let checkoutIntentResponse = try? JSONDecoder().decode(CheckoutIntentResponse.self, from: data)
            completion(checkoutIntentResponse?.clientSecret)
            
        }.resume()
        
        
    }
    
    
    
    var body: some View {
        NavigationStack {
            VStack (alignment: .leading) {
                Text("MY CART")
                    .font(.system(size: 20, weight: .light))
                    .foregroundColor(.darkGray)
                    .padding()
                
                // card products
                if order.orderItems.count > 0 {
                    ScrollView(showsIndicators: false) {
                        VStack() {
                            ForEach(order.orderItems) { orderItem in
                                OrderItemView(orderItem: orderItem)
                            }
                        }
                    }
                    
                    Spacer()
                    
                    TotalView()
                    
                    // Place your order
                    NavigationLink(isActive: $isActive){
                        CheckoutView()
                    } label: {
                        HStack {
                            Spacer()
                            Button("GO TO CHECKOUT") {
                                startCheckout { clientSecret in
                                    PaymentConfig.shared.paymentIntentClientSecret = clientSecret
                                }
                                DispatchQueue.main.async {
                                    isActive = true
                                }
                            }
                            .foregroundColor(.white)
                            .font(.system(size: 14, weight: .light))
                            .padding(7)
                            .background(Color(UIColor.black))
                            Spacer()
                        }
                        
                    }
                } else {
                    EmptyCartView()
                }
                
            }
            .padding(20)
        }
    }
}


struct OrderItemView: View {
    
    @EnvironmentObject var order: Order
    var orderItem: OrderItem
    
    var body: some View {
        
        
        
        
        HStack{
            AsyncImage(url: URL(string: orderItem.product.imageURL)) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 100, height: 100)
            
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text("\(orderItem.product.title)")
                        .font(.system(size: 12, weight: .light))
                        .foregroundColor(.darkGray)
                    Text("$\(orderItem.product.price, specifier: "%.2f")")
                        .foregroundColor(.darkGray)
                        .font(.system(size: 12, weight: .light))
                }
                .fixedSize(horizontal: false, vertical: true)
                
                Spacer(minLength: 20)
                
                
                HStack {
                    Button(action: {
                        self.order.addToCart(product: orderItem.product)
                    }, label: {
                        Image(systemName: "plus")
                    }).accentColor(.darkGray)
                    
                    Text("\(orderItem.number)")
                        .font(.system(size: 14, weight: .light))
                        .foregroundColor(.darkGray)
                    
                    Button(action: {
                        self.order.removeProductFromCart(product: orderItem.product)
                    }, label: {
                        Image(systemName: "minus")
                    }).accentColor(.darkGray)
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

struct TotalView: View {
    @EnvironmentObject var order: Order
    
    var body: some View {
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
    }
}


struct OrderView_Previews: PreviewProvider {
    static var previews: some View {
        let order = Order()
        order.orderItems = Array(mockOrderItems.prefix(upTo: 3))
        return CartView().environmentObject(order)
    }
}
