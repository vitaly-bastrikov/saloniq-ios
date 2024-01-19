//
//  PaymentHandler.swift
//  saloniq
//
//  Created by Vitaly Bastrikov on 2024-01-18.
//

import Foundation
import UIKit
import PassKit

typealias PaymentCompletionHandler = (Bool, [String: Any]? ) -> Void

class PaymentHandler: NSObject {
    var paymentController: PKPaymentAuthorizationController?
    var paymentStatus = PKPaymentAuthorizationStatus.failure
    var paymentDataJson: [String: Any]?
    var completionHandler: PaymentCompletionHandler!
    
    func startPayment(items: [PKPaymentSummaryItem], completion: @escaping PaymentCompletionHandler) {
        
        let paymentRequest = PKPaymentRequest()
        paymentRequest.paymentSummaryItems = items
        paymentRequest.merchantIdentifier = "merchant.io.bastrikov.saloniq "
        paymentRequest.merchantCapabilities = .threeDSecure
        paymentRequest.countryCode = "CA"
        paymentRequest.currencyCode = "CAD"
        paymentRequest.supportedNetworks = [.visa, .masterCard]
        
        // Display the payment request.
        paymentController =  PKPaymentAuthorizationController(paymentRequest: paymentRequest)
        paymentController?.delegate = self
        paymentController?.present(completion: { (presented: Bool )in
            if presented {
                print("Presented Payment Controller")
            } else {
                print("Failed to present payment controller")
                self.completionHandler(false, nil)
            }
        })
    }
}

extension PaymentHandler: PKPaymentAuthorizationControllerDelegate {
    
    // Handels token generation
    func paymentAuthorizationController(_ controller: PKPaymentAuthorizationController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        
        self.paymentStatus =  .success
        do {
            if let json = try JSONSerialization.jsonObject(with: payment.token.paymentData, options: []) as? [String: Any] {
                self.paymentDataJson = json
                completion(PKPaymentAuthorizationResult(status: .success, errors: [Error]()))
            }
        } catch let error as NSError {
            print("Failed to load: \(error.localizedDescription)")
            completion(PKPaymentAuthorizationResult(status: .failure, errors:  [Error]()))
        }
    }
    
    // Handels payment is done
    func paymentAuthorizationControllerDidFinish(_ controller: PKPaymentAuthorizationController) {
        controller.dismiss {
            DispatchQueue.main.async {
                if self.paymentStatus == .success {
                    self.completionHandler!(true, self.paymentDataJson)
                    print("Payment Successful")
                } else {
                    self.completionHandler!(false, nil)
                    print("Payment Unsuccessful")
                }
            }
        }
    }
}
