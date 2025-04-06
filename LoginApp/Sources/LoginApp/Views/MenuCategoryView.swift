import SwiftUI

struct MenuCategoryView: View {
    let categoryName: String
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedFilter: String? = nil
    @State private var selectedMenuItem: MenuItem? = nil
    
    // Sample subcategories
    private let subcategories = ["All", "Burgers", "Pizza", "Sides", "Drinks"]
    
    // Sample menu items
    private let menuItems: [MenuItem] = [
        MenuItem(
            id: "1",
            name: "Classic Cheeseburger",
            description: "Juicy beef patty with melted cheese, lettuce, tomato, and special sauce",
            price: 9.99,
            imageURL: "https://images.unsplash.com/photo-1568901346375-23c9450c58cd?ixlib=rb-4.0.3",
            isVegetarian: false,
            category: "Burgers"
        ),
        MenuItem(
            id: "2",
            name: "Veggie Burger",
            description: "Plant-based patty with lettuce, tomato, onion, and vegan mayo",
            price: 8.99,
            imageURL: "https://images.unsplash.com/photo-1520072959219-c595dc870360?ixlib=rb-4.0.3",
            isVegetarian: true,
            category: "Burgers"
        ),
        MenuItem(
            id: "3",
            name: "Margherita Pizza",
            description: "Classic pizza with tomato sauce, mozzarella, and fresh basil",
            price: 12.99,
            imageURL: "https://images.unsplash.com/photo-1574071318508-1cdbab80d002?ixlib=rb-4.0.3",
            isVegetarian: true,
            category: "Pizza"
        ),
        MenuItem(
            id: "4",
            name: "Pepperoni Pizza",
            description: "Tomato sauce, mozzarella, and spicy pepperoni slices",
            price: 14.99,
            imageURL: "https://images.unsplash.com/photo-1628840042765-356cda07504e?ixlib=rb-4.0.3",
            isVegetarian: false,
            category: "Pizza"
        ),
        MenuItem(
            id: "5",
            name: "French Fries",
            description: "Crispy golden fries served with ketchup",
            price: 4.99,
            imageURL: "https://images.unsplash.com/photo-1573080496219-bb080dd4f877?ixlib=rb-4.0.3",
            isVegetarian: true,
            category: "Sides"
        ),
        MenuItem(
            id: "6",
            name: "Onion Rings",
            description: "Beer-battered onion rings with dipping sauce",
            price: 5.99,
            imageURL: "https://images.unsplash.com/photo-1639024471283-03518883512d?ixlib=rb-4.0.3",
            isVegetarian: true,
            category: "Sides"
        ),
        MenuItem(
            id: "7",
            name: "Cola",
            description: "Classic cola with ice",
            price: 2.99,
            imageURL: "https://images.unsplash.com/photo-1622483767028-3f66f32aef97?ixlib=rb-4.0.3",
            isVegetarian: true,
            category: "Drinks"
        ),
        MenuItem(
            id: "8",
            name: "Milkshake",
            description: "Vanilla milkshake topped with whipped cream",
            price: 4.99,
            imageURL: "https://images.unsplash.com/photo-1579954115545-a95591f28bfc?ixlib=rb-4.0.3",
            isVegetarian: true,
            category: "Drinks"
        )
    ]
    
    // Filtered menu items based on selected subcategory
    private var filteredItems: [MenuItem] {
        guard let filter = selectedFilter, filter != "All" else {
            return menuItems
        }
        
        return menuItems.filter { $0.category == filter }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Custom navigation bar
                customNavigationBar
                
                // Category header
                categoryHeader
                
                // Subcategory filters
                subcategoryFilters
                
                // Menu items list
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(filteredItems) { item in
                            MenuItemRow(item: item)
                                .onTapGesture {
                                    selectedMenuItem = item
                                }
                        }
                    }
                    .padding()
                }
                .background(Color.black.opacity(0.92))
                
                // Tab bar
                tabBar
            }
            .background(Color.black)
            .edgesIgnoringSafeArea(.bottom)
            .fullScreenCover(item: $selectedMenuItem) { item in
                MenuItemDetailView(item: item)
            }
        }
        .navigationBarHidden(true)
    }
    
    private var customNavigationBar: some View {
        HStack {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "chevron.left")
                    .foregroundColor(.white)
                    .padding()
            }
            
            Spacer()
            
            Text(categoryName)
                .font(.headline)
                .foregroundColor(.white)
            
            Spacer()
            
            Button(action: {
                // Search action
            }) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.white)
                    .padding()
            }
        }
        .padding(.horizontal)
        .background(Color.black.opacity(0.8))
    }
    
    private var categoryHeader: some View {
        ZStack(alignment: .bottomLeading) {
            // Category banner image
            AsyncImage(url: URL(string: menuItems.first?.imageURL ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 180)
                    .blur(radius: 3)
                    .overlay(Color.black.opacity(0.3))
            } placeholder: {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 180)
            }
            
            // Category information
            VStack(alignment: .leading, spacing: 4) {
                Text(categoryName)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text("\(menuItems.count) items")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
    }
    
    private var subcategoryFilters: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(subcategories, id: \.self) { subcategory in
                    FilterButton(
                        title: subcategory,
                        isSelected: selectedFilter == subcategory
                    ) {
                        selectedFilter = subcategory
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .background(Color.black.opacity(0.9))
    }
    
    private var tabBar: some View {
        HStack {
            tabItem(icon: "house", label: "Menu", isSelected: false)
            tabItem(icon: "fork.knife", label: "Reserve Table", isSelected: false)
            tabItem(icon: "gift", label: "Buy Gift Now", isSelected: false)
        }
        .padding(.vertical, 12)
        .background(Color.black.opacity(0.8))
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.gray.opacity(0.3)),
            alignment: .top
        )
    }
    
    private func tabItem(icon: String, label: String, isSelected: Bool) -> some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 20))
            Text(label)
                .font(.caption2)
        }
        .foregroundColor(isSelected ? .blue : .gray)
        .frame(maxWidth: .infinity)
    }
}

struct FilterButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Color.blue : Color.gray.opacity(0.2))
                .foregroundColor(isSelected ? .white : .gray)
                .cornerRadius(20)
        }
    }
}

struct MenuItemRow: View {
    let item: MenuItem
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Item image
            AsyncImage(url: URL(string: item.imageURL)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 80)
                    .cornerRadius(8)
            } placeholder: {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 80, height: 80)
                    .cornerRadius(8)
            }
            
            // Item details
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(item.name)
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    // Veg/Non-veg indicator
                    VegNonVegIndicator(isVegetarian: item.isVegetarian)
                }
                
                Text(item.description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .lineLimit(2)
                
                HStack {
                    Text("$\(String(format: "%.2f", item.price))")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button(action: {
                        // Add to cart action
                    }) {
                        Text("ADD")
                            .font(.caption)
                            .fontWeight(.bold)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(4)
                    }
                }
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
}

struct MenuCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        MenuCategoryView(categoryName: "Food Menu")
            .preferredColorScheme(.dark)
    }
}