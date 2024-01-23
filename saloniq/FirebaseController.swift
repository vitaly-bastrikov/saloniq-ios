//
//  FirebaseController.swift
//  saloniq
//
//  Created by Vitaly Bastrikov on 2024-01-20.
//

import Foundation
import Firebase

class FirebaseController: ObservableObject {
    
    @Published var products = [Product]()
    
    func downloadProducts() {
        
        // Get a reference to the database
        let db = Firestore.firestore()
        
        // Read the documents at a specific path
        db.collection("products").getDocuments { snapshot, error in
            
            if error == nil {
                if let snapshot = snapshot {
                    DispatchQueue.main.async {
                        self.products = snapshot.documents.map { d in
                            
                            let product = Product(
                                title: d["title"] as? String ?? "",
                                price: d["price"] as? Double ?? 0.0,
                                description: d["description"] as? String ?? "",
                                imageURL: d["imageurl"] as? String ?? ""
                                
                                
                            )
                            print("fetched product: \(product)")
                            
                            return product
                        }
                    }
                    
                    
                }
            }
            else {
                // Handle the error
            }
        }
    }
    
    func addOrder(firstName: String, lastName: String, order: Order, street: String, city: String, phoneNumner: String) {
        let db = Firestore.firestore()
        var message = ""
        
        message.append("<html> <body> <h1>New Order</h1>")
        message.append("<h2>Total: $\(order.total)</h2>")
        message.append("<p>Customer Name: \(firstName) \(lastName) </p> ")
        
        // address
        message.append("<h2>Address</h2>")
        message.append("<p>City: \(city) </p>")
        message.append("<p>Street: \(street) </p>")
        message.append("<p>Phone Number: \(phoneNumner) </p>")
        
        // order
        message.append("<h2>Order</h2> ")
        for orderItem in order.orderItems {
            message.append("<p> Product: \(orderItem.product.title) x \(orderItem.number) </p>")
        }
        
        
        db.collection("mail").addDocument(data: [
            "to": "bastrikov.vitaly@gmail.com",
            "message": [
              "subject": "\(firstName) \(lastName) has placed the order",
              
              "html": "<html> <body> \(message) </body> </html>"
            ]
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
}
