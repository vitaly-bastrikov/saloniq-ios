//
//  PaymentConfig.swift
//  saloniq
//
//  Created by Vitaly Bastrikov on 2024-01-19.
//

import Foundation

class PaymentConfig {
    var paymentIntentClientSecret: String?
    static var shared: PaymentConfig = PaymentConfig()
    
    private init() {}
}
