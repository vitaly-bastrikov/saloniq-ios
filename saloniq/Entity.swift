//
//  Entity.swift
//  saloni
//
//  Created by Vitaly Bastrikov on 2024-01-16.
//

import Foundation
import SwiftUI
import Firebase

struct Product: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    
    var title: String
    var price: Double
    var description: String = mockDescription
    var imageURL: String
}

struct OrderItem: Identifiable, Encodable {
    var id: UUID = UUID()
    var product: Product
    var number: Int
}

// Our observable object class
class Order: ObservableObject {
    @Published var orderItems: [OrderItem] = []
    
    var total: Double {
        var temp = 0.0
        for orderItem in orderItems {
            temp += Double(orderItem.product.price) * Double(orderItem.number)
        }
        return temp
    }
    
    func addToCart(product: Product) {
        var index = -1
        
        for i in 0..<(orderItems.count) {
            if orderItems[i].product.id == product.id {
                index = i
                break
            }
        }
        
        if index != -1 {
            orderItems[index].number += 1
        } else {
            orderItems.append(OrderItem(product: product, number: 1))
        }
    }
    
    func removeProductFromCart(product: Product) {
        
        var index = -1
        
        for i in 0..<(orderItems.count) {
            if orderItems[i].product.id == product.id {
                index = i
                break
            }
        }
        
        if index != -1 {
            orderItems[index].number -= 1
            if orderItems[index].number == 0 {
                orderItems.remove(at: index)
            }
        }

    }
    
}

struct CheckoutIntentResponse: Decodable {
    let clientSecret: String
}

let mockDescription = "From Science to Beauty With more than 30 years of dedicated research, at L'Oréal Paris, we know your skin inside and out, whether it’s normal, dry, dull, aging or combination.  \n \nOur skincare creams are developed and rigorously tested with leading skin experts and scientists worldwide. Proven science, our cutting-edge innovations are captured in luxurious textures for a sumptuous skincare experience."


var mockProducts: [Product] = [
    Product(title: "LEAVE IN FOR HAIR REPAIR", price: 9.99, imageURL: "https://firebasestorage.googleapis.com/v0/b/saloniq-f4fd8.appspot.com/o/product-images%2Fimg1.jpg?alt=media&token=fe7c3502-cf00-4cd4-ad8b-46ea620dfb9c"),
    Product(title: "SHAMPOO FOR HAIR REPAIR", price: 19.99, imageURL: "https://firebasestorage.googleapis.com/v0/b/saloniq-f4fd8.appspot.com/o/product-images%2Fimg2.jpeg?alt=media&token=6bc0873b-6a41-4838-badf-56003ef4a634"),
    Product(title: "HAIR REPAIR MASK", price: 29.99, imageURL: "https://firebasestorage.googleapis.com/v0/b/saloniq-f4fd8.appspot.com/o/product-images%2Fimg3.jpeg?alt=media&token=5749b1a3-3064-4af7-83b6-886b2dd376a5"),
    Product(title: "HAIR BRUSH", price: 4.99, imageURL: "https://firebasestorage.googleapis.com/v0/b/saloniq-f4fd8.appspot.com/o/product-images%2Fimg4.jpeg?alt=media&token=bf9b310d-22bb-454e-b210-b84ecc8df661"),
    Product(title: "HAIR LOSS PRODUCTS", price: 99.99, imageURL: "https://firebasestorage.googleapis.com/v0/b/saloniq-f4fd8.appspot.com/o/product-images%2Fimg5.jpeg?alt=media&token=91787785-dfc2-4c0c-8ba3-e1aa6d046cd1"),
    Product(title: "HAIR SCRUB", price: 11.99, imageURL: "https://firebasestorage.googleapis.com/v0/b/saloniq-f4fd8.appspot.com/o/product-images%2Fimg6.jpeg?alt=media&token=ee084323-1305-420e-be7e-1ad732a3fd16"),
    Product(title: "HEAT PROTECTANTS", price: 12.99, imageURL: "https://firebasestorage.googleapis.com/v0/b/saloniq-f4fd8.appspot.com/o/product-images%2Fimg7.jpeg?alt=media&token=02e741d2-13f1-4c05-b2ef-11150a92540c"),
    Product(title: "TOOLS", price: 0.99, imageURL: "https://firebasestorage.googleapis.com/v0/b/saloniq-f4fd8.appspot.com/o/product-images%2Fimg8.jpeg?alt=media&token=15ca4413-5f7d-4bd6-ae78-99dd26325156"),
]

var mockOrderItems: [OrderItem] = mockProducts.map { OrderItem(product: $0, number: 1) }

var categories: [String] = ["HAIR CARE","SKIN CARE","BODY CARE","PROBRANDS"]
