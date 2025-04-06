import SwiftUI

struct MenuItemDetailView: View {
    let item: MenuItem
    @Environment(\.presentationMode) var presentationMode
    @State private var quantity = 1
    
    var body: some View {
        VStack(spacing: 0) {
            // Custom navigation bar
            customNavigationBar
            
            ScrollView {
                VStack(spacing: 0) {
                    // Item image
                    itemImage
                    
                    // Item details
                    itemDetails
                    
                    // Quantity selector
                    quantitySelector
                    
                    // Add to cart button
                    addToCartButton
                }
            }
        }
        .background(Color.black)
        .edgesIgnoringSafeArea(.all)
    }
    
    private var customNavigationBar: some View {
        HStack {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "xmark")
                    .foregroundColor(.white)
                    .padding()
            }
            
            Spacer()
            
            Button(action: {
                // Share action
            }) {
                Image(systemName: "square.and.arrow.up")
                    .foregroundColor(.white)
                    .padding()
            }
        }
        .padding(.horizontal)
        .background(Color.black.opacity(0.8))
    }
    
    private var itemImage: some View {
        ZStack(alignment: .bottomTrailing) {
            AsyncImage(url: URL(string: item.imageURL)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 320)
            } placeholder: {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 320)
            }
            
            VegNonVegIndicator(isVegetarian: item.isVegetarian)
                .padding()
                .background(
                    Circle()
                        .fill(Color.white)
                        .frame(width: 32, height: 32)
                )
                .padding()
        }
    }
    
    private var itemDetails: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Title and price
            HStack {
                Text(item.name)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Spacer()
                
                Text("$\(String(format: "%.2f", item.price))")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            
            // Description
            Text(item.description)
                .font(.body)
                .foregroundColor(.gray)
                .fixedSize(horizontal: false, vertical: true)
            
            // Divider
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(height: 1)
                .padding(.vertical, 8)
            
            // Customization options
            VStack(alignment: .leading, spacing: 12) {
                Text("Customization")
                    .font(.headline)
                    .foregroundColor(.white)
                
                customizationOption(title: "Add extra cheese", price: "+$1.50")
                customizationOption(title: "Add bacon", price: "+$2.00")
                customizationOption(title: "Add avocado", price: "+$1.75")
            }
            
            // Divider
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(height: 1)
                .padding(.vertical, 8)
            
            // Nutrition info
            VStack(alignment: .leading, spacing: 12) {
                Text("Nutrition Information")
                    .font(.headline)
                    .foregroundColor(.white)
                
                HStack(spacing: 24) {
                    nutritionItem(value: "450", label: "Calories")
                    nutritionItem(value: "22g", label: "Protein")
                    nutritionItem(value: "30g", label: "Carbs")
                    nutritionItem(value: "12g", label: "Fat")
                }
            }
        }
        .padding()
        .background(Color.black.opacity(0.92))
    }
    
    private func customizationOption(title: String, price: String) -> some View {
        HStack {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.white)
            
            Spacer()
            
            Text(price)
                .font(.subheadline)
                .foregroundColor(.gray)
            
            Image(systemName: "plus.circle")
                .foregroundColor(.blue)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
    }
    
    private func nutritionItem(value: String, label: String) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.headline)
                .foregroundColor(.white)
            
            Text(label)
                .font(.caption)
                .foregroundColor(.gray)
        }
    }
    
    private var quantitySelector: some View {
        HStack {
            Text("Quantity")
                .font(.headline)
                .foregroundColor(.white)
            
            Spacer()
            
            HStack(spacing: 16) {
                Button(action: {
                    if quantity > 1 {
                        quantity -= 1
                    }
                }) {
                    Image(systemName: "minus")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 32, height: 32)
                        .background(Color.gray.opacity(0.3))
                        .clipShape(Circle())
                }
                
                Text("\(quantity)")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(minWidth: 40)
                
                Button(action: {
                    quantity += 1
                }) {
                    Image(systemName: "plus")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 32, height: 32)
                        .background(Color.blue)
                        .clipShape(Circle())
                }
            }
        }
        .padding()
        .background(Color.black.opacity(0.95))
    }
    
    private var addToCartButton: some View {
        Button(action: {
            // Add to cart with current quantity
        }) {
            HStack {
                Text("Add to Cart")
                    .font(.headline)
                    .foregroundColor(.white)
                
                Spacer()
                
                Text("$\(String(format: "%.2f", item.price * Double(quantity)))")
                    .font(.headline)
                    .foregroundColor(.white)
            }
            .padding()
            .background(Color.blue)
            .cornerRadius(8)
            .padding()
        }
    }
}

struct MenuItemDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MenuItemDetailView(
            item: MenuItem(
                id: "1",
                name: "Classic Cheeseburger",
                description: "Juicy beef patty with melted cheese, lettuce, tomato, and special sauce.",
                price: 9.99,
                imageURL: "https://images.unsplash.com/photo-1568901346375-23c9450c58cd?ixlib=rb-4.0.3",
                isVegetarian: false,
                category: "Burgers"
            )
        )
        .preferredColorScheme(.dark)
    }
}