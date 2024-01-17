
import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var order: Order
    
    
    var body: some View {
        VStack {
            
            // logo
            HStack{
                Image(.saloniqLogo)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 40)
                Spacer(minLength: 40)
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
            .padding(5)
            
            // Products
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    ForEach(mockProducts) { product in
                        ExtractedView(product: product)
                        
                    }
                }
            }
            .padding()
            
            Spacer()
        }
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        let order = Order()
        order.products = Array(mockProducts.prefix(upTo: 3))
        order.products = []
        // any more parameters set up here
        
        return HomeView().environmentObject(order)
    }
}

struct ExtractedView: View {
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
            
            
            
            VStack(alignment: .leading) {
                Text("\(product.title)")
                    .font(.system(size: 12, weight: .light))
                    .foregroundColor(.darkGray)
                Text("$\(product.price)")
                    .foregroundColor(.darkGray)
                    .font(.system(size: 10, weight: .light))
            }
            .padding()
            
            Spacer()
            
            Button("ADD TO CART") {
                order.products.append(product)
            }
            .foregroundColor(.white)
            .font(.system(size: 12, weight: .light))
            .padding(7)
            .background(Color(UIColor.darkGray))
            
        }
        .padding()
    }
}

extension Color {
    static let darkGray = Color(red: 0.3, green: 0.3, blue: 0.3)
    static let lightBlack = Color(red: 0.6, green: 0.6, blue: 0.6)
}
