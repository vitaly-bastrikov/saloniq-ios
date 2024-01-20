//
//  CheckoutView.swift
//  saloniq
//
//  Created by Vitaly Bastrikov on 2024-01-19.
//

import SwiftUI
import Stripe

struct CheckoutView: View {
    @EnvironmentObject var order: Order
    @State private var paymentMethodParams: STPPaymentMethodParams?
    @State private var message: String = ""
    @State private var debugMessage: String = ""
    @State private var isSuccess: Bool = false
    
    // Delivery address
    @State private var City: String = ""
    @State private var Street: String = ""
    
    
    let paymentGatewayController = PaymentGatewayController()
    
    private func pay() {
        
        debugMessage = "got client secret"
        guard let clientSecret = PaymentConfig.shared.paymentIntentClientSecret else {
            debugMessage = "client secret error"
            return
        }
        
        let paymentIntentParams = STPPaymentIntentParams(clientSecret: clientSecret)
        paymentIntentParams.paymentMethodParams = paymentMethodParams
        
        
        paymentGatewayController.submitPayment(intent: paymentIntentParams) { status, intent, error in
            
            switch status {
            case .failed:
                print(error?.localizedDescription as Any)
                message = "Failed"
            case.canceled:
                message = "Cancelled"
            case .succeeded:
                message = "Your payment has been successfully completed!"
                
            }
        }
        order.products = []
    }
    
    
    var body: some View {
        VStack {
            HStack {
                Text("CHECKOUT")
                    .font(.system(size: 20, weight: .light))
                    .foregroundColor(.darkGray)
                    .padding(EdgeInsets(top: 20, leading: 20, bottom: 0, trailing: 0))
                Spacer()
            }
            
            HStack {
                Text("TOTAL $\(order.total, specifier: "%.2f")")
                    .font(.system(size: 16, weight: .light))
                    .foregroundColor(.black)
                    .padding(EdgeInsets(top: 20, leading: 20, bottom: 0, trailing: 0))
                Spacer()
            }
            
            
            
            
            HStack {
                Text("PAYMENT METHOD")
                    .font(.system(size: 16, weight: .light))
                    .foregroundColor(.darkGray)
                    .padding(EdgeInsets(top: 20, leading: 20, bottom: 0, trailing: 0))
                Spacer()
            }
            
            STPPaymentCardTextField.Representable.init(paymentMethodParams: $paymentMethodParams)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            
            
            HStack {
                Text("SHIPPING ADDRESS")
                    .font(.system(size: 16, weight: .light))
                    .foregroundColor(.darkGray)
                    .padding(EdgeInsets(top: 20, leading: 20, bottom: 0, trailing: 0))
                Spacer()
            }
            
            TextField("Street", text: $Street)
                .textFieldStyle(.roundedBorder)
                .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
            TextField("City", text: $City)
                .textFieldStyle(.roundedBorder)
                .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
            TextField("Phone Number", text: $City)
                .textFieldStyle(.roundedBorder)
                .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
            
            
            Spacer()
            
            if order.products.count == 0 {
                Image(systemName: "checkmark.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50)
                Text("YOUR ORDER HAS BEEN PLACED SUCCESSFULLY")
                    .multilineTextAlignment(.center)
                    .font(.system(size: 16, weight: .light))
                    .foregroundColor(.darkGray)
                    .padding(EdgeInsets(top: 20, leading: 20, bottom: 0, trailing: 0))
                
                Spacer()
                
            } else {
                Button("PLACE ORDER") {
                    pay()
                }
                .foregroundColor(.white)
                .font(.system(size: 16, weight: .light))
                .padding(10)
                .background(Color(UIColor.black))
                
                Text(message).font(.headline)
                Text(debugMessage).font(.headline)
                
                
            }
            
        }
        .padding(10)
        
    }
}

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        let order = Order()
        order.products = Array(mockProducts.prefix(upTo: 3))
        // any more parameters set up here
        
        return CheckoutView().environmentObject(order)
    }
}
