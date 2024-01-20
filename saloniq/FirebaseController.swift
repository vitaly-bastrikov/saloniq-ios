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
    
}
