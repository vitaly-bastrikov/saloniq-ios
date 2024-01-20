
import SwiftUI

struct ShopView: View {
    
    @EnvironmentObject var order: Order
    
    var body: some View {
        
        VStack(spacing: 30) {
            
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
            HStack{
                ForEach(categories, id: \.self) { category in
                    Text(category)
                        .font(.system(size: 12, weight: .light))
                        .foregroundColor(.darkGray)
                        .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                }
            }
            
            // Products
            ScrollView(showsIndicators: false) {
                VStack(spacing: 15) {
                    ForEach(mockOrderItems) { orderItem in
                        OrderItemCellView(orderItem: orderItem)
                    }
                }.padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
            }
            
            Spacer()
        }
        
    }
}

struct OrderItemCellView: View {
    @EnvironmentObject var order: Order
    @State private var showProductView = false
    
    var orderItem: OrderItem
    
    var body: some View {
        
        HStack(alignment: .center){
            AsyncImage(url: URL(string: orderItem.product.imageURL)) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50)
                
            } placeholder: {
                ProgressView()
            }
            
            
            Text("\(orderItem.product.title)")
                .font(.system(size: 12, weight: .light))
                .foregroundColor(.darkGray)
            
            Spacer()
            
            
            Text("$\(orderItem.product.price, specifier: "%.2f")")
                .foregroundColor(.darkGray)
                .font(.system(size: 12, weight: .light))
            
        }
        .onTapGesture {
            showProductView.toggle()
        }
        .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
        .sheet(isPresented: $showProductView) {
            ProductView(product: orderItem.product)
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
