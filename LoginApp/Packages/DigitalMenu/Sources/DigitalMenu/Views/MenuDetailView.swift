import SwiftUI

public struct MenuDetailView: View {
    let menuItem: MenuItem
    @State private var quantity: Int = 1
    
    public init(menuItem: MenuItem) {
        self.menuItem = menuItem
    }
    
    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Image placeholder
                if let _ = menuItem.imageUrl {
                    ZStack {
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 250)
                        
                        Text("Image")
                            .font(.title)
                            .foregroundColor(.gray)
                    }
                }
                
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text(menuItem.name)
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        Text(menuItem.formattedPrice)
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.blue)
                    }
                    
                    Text(menuItem.description)
                        .font(.body)
                        .foregroundColor(.secondary)
                    
                    Divider()
                    
                    if menuItem.isAvailable {
                        HStack {
                            Text("Quantity")
                                .font(.headline)
                            
                            Spacer()
                            
                            Button(action: {
                                if quantity > 1 {
                                    quantity -= 1
                                }
                            }) {
                                Image(systemName: "minus.circle")
                                    .font(.title2)
                            }
                            
                            Text("\(quantity)")
                                .font(.headline)
                                .padding(.horizontal, 8)
                            
                            Button(action: {
                                quantity += 1
                            }) {
                                Image(systemName: "plus.circle")
                                    .font(.title2)
                            }
                        }
                        
                        Divider()
                        
                        Button(action: {
                            // Add to cart action would go here
                        }) {
                            HStack {
                                Spacer()
                                Text("Add to Cart - \(totalPrice)")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Spacer()
                            }
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                        }
                    } else {
                        Text("This item is currently unavailable")
                            .font(.headline)
                            .foregroundColor(.red)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.red.opacity(0.1))
                            .cornerRadius(10)
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Item Details")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var totalPrice: String {
        let total = menuItem.price * Double(quantity)
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        return formatter.string(from: NSNumber(value: total)) ?? "$\(total)"
    }
}
