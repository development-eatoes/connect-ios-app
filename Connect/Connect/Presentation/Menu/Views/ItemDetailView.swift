import SwiftUI

struct ItemDetailView: View {
    @ObservedObject var viewModel: MenuViewModel
    let item: MenuItem
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Item image
                RemoteImage(
                    url: item.imageURL,
                    placeholder: item.name
                )
                .aspectRatio(contentMode: .fill)
                .frame(height: 250)
                .frame(maxWidth: .infinity)
                .clipped()
                
                VStack(alignment: .leading, spacing: 16) {
                    // Item header with name and veg indicator
                    HStack(alignment: .center, spacing: 12) {
                        VegNonVegIndicator(isVegetarian: item.isVegetarian)
                        
                        Text(item.name)
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                    
                    // Price
                    Text("$\(String(format: "%.2f", item.price))")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    // Description
                    Text("Description")
                        .font(.headline)
                        .padding(.top, 8)
                    
                    Text(item.description)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    // Add to cart button
                    Button(action: {
                        // Add to cart functionality
                    }) {
                        HStack {
                            Spacer()
                            Text("Add to Cart")
                                .font(.headline)
                                .foregroundColor(.white)
                            Spacer()
                        }
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                    }
                    .padding(.top, 24)
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.selectMenuItem(item)
        }
    }
}