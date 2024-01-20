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
        request.httpBody = try? JSONEncoder().encode(order.products)
        
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
                if order.products.count > 0 {
                    ScrollView(showsIndicators: false) {
                        VStack() {
                            ForEach(order.products) { product in
                                OrderItemView(product: product)
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

struct OrderView_Previews: PreviewProvider {
    static var previews: some View {
        let order = Order()
        order.products = Array(mockProducts.prefix(upTo: 3))
//        order.products = []
        
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


