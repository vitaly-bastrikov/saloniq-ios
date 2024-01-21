
import SwiftUI

struct ShopView: View {
    
    @EnvironmentObject var order: Order
    @ObservedObject var firebaseController = FirebaseController()
    // var categories: [String] = ["HAIR CARE","SKIN CARE","BODY CARE","PROBRANDS"]
    
    var body: some View {
        
        ScrollView {
            VStack(alignment: .leading, spacing: 30) {
                
                // logo
                HStack{
                    Image(.saloniqLogo)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 40)
                    Spacer(minLength: 40)
                    VStack(content: {
                        Image(systemName: "\(order.orderItems.count).circle").foregroundColor(.gray)
                        Image(systemName: "basket").foregroundColor(.gray)
                        
                    }).padding()
                }
                .padding()
                
                // Categories
                Text("HAIR CARE")
                    .font(.system(size: 16, weight: .light))
                    .foregroundColor(.darkGray)
                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                
                
                
                // Products
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(firebaseController.products) { product in
                            OrderItemCellView(product: product)
                        }
                    }.padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                }
                Spacer()
                
                // Categories
                Text("SKIN CARE")
                    .font(.system(size: 16, weight: .light))
                    .foregroundColor(.darkGray)
                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                
                
                
                // Products
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(firebaseController.products) { product in
                            OrderItemCellView(product: product)
                        }
                    }.padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                }
                Spacer()
                
                // Categories
                Text("BODY CARE")
                    .font(.system(size: 16, weight: .light))
                    .foregroundColor(.darkGray)
                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                
                
                
                // Products
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(firebaseController.products) { product in
                            OrderItemCellView(product: product)
                        }
                    }.padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                }
                
                Spacer()
            }
        }
        .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
        .onAppear(perform: {
            firebaseController.downloadProducts()
        })
        
    }
}
      
    



struct OrderItemCellView: View {
    @EnvironmentObject var order: Order
    @State private var showProductView = false
    
    
    var product: Product
    
    var body: some View {
        
        VStack(alignment: .center){
            AsyncImage(url: URL(string: product.imageURL)) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100)
                
            } placeholder: {
                ProgressView()
            }
            
            VStack(alignment: .leading) {
                Text("\(product.title)")
                    .font(.system(size: 12, weight: .light))
                    .foregroundColor(.darkGray)
                
                
                Text("$\(product.price, specifier: "%.2f")")
                    .foregroundColor(.darkGray)
                    .font(.system(size: 12, weight: .light))
            }
        }
        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 20))
        .onTapGesture {
            showProductView.toggle()
            print("image: \(product.imageURL)")
        }

        .sheet(isPresented: $showProductView) {
            ProductView(product: product)
        }
    }
    
}

extension Color {
    static let darkGray = Color(red: 0.3, green: 0.3, blue: 0.3)
    static let lightBlack = Color(red: 0.6, green: 0.6, blue: 0.6)
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        let order = Order()
        order.orderItems = Array(mockOrderItems.prefix(upTo: 3))
        return ShopView().environmentObject(order)
    }
}
