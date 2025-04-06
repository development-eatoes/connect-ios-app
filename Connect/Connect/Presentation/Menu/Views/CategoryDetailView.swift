import SwiftUI

struct CategoryDetailView: View {
    @ObservedObject var viewModel: MenuViewModel
    let category: MenuCategory
    @State private var navigateToItem: MenuItem?
    
    var body: some View {
        VStack(spacing: 0) {
            // App Bar
            HStack {
                Text(category.name)
                    .font(.title2)
                    .fontWeight(.bold)
                
                Spacer()
            }
            .padding()
            .background(Color(.systemBackground))
            .shadow(color: Color.black.opacity(0.1), radius: 2)
            
            // Menu Items List
            if viewModel.isLoading {
                ProgressView()
                    .padding(.top, 100)
            } else if viewModel.menuItems.isEmpty {
                EmptyStateView(message: "No items available in this category")
            } else {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(viewModel.menuItems, id: \.id) { item in
                            NavigationLink(
                                destination: ItemDetailView(
                                    viewModel: viewModel,
                                    item: item
                                ),
                                tag: item,
                                selection: $navigateToItem
                            ) {
                                MenuItemCard(item: item)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(16)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.selectCategory(category)
        }
    }
}

struct MenuItemCard: View {
    let item: MenuItem
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Veg/Non-veg indicator
            VegNonVegIndicator(isVegetarian: item.isVegetarian)
                .padding(.top, 4)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(item.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(item.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                
                Text("$\(String(format: "%.2f", item.price))")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)
            }
            
            Spacer()
            
            RemoteImage(
                url: item.imageURL,
                placeholder: item.name
            )
            .frame(width: 80, height: 80)
            .cornerRadius(8)
        }
        .padding(16)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 2)
    }
}