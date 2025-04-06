import SwiftUI
import Combine

public struct MenuListView: View {
    @ObservedObject private var viewModel: MenuViewModel
    @State private var selectedCategory: String? = nil
    
    public init(viewModel: MenuViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        NavigationView {
            ZStack {
                if viewModel.isLoading {
                    ProgressView("Loading menu...")
                } else if let error = viewModel.error {
                    VStack {
                        Text("Error loading menu")
                            .font(.headline)
                            .padding(.bottom)
                        
                        Text(error)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                        
                        Button("Retry") {
                            viewModel.fetchMenu()
                        }
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding(.top)
                    }
                    .padding()
                } else {
                    menuContent
                }
            }
            .navigationTitle("Digital Menu")
            .onAppear {
                viewModel.fetchMenu()
            }
        }
    }
    
    private var menuContent: some View {
        VStack {
            // Category selector
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(viewModel.categories, id: \.id) { category in
                        CategoryButton(
                            name: category.name,
                            isSelected: selectedCategory == category.id
                        ) {
                            selectedCategory = category.id
                        }
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical, 8)
            
            // Menu items list
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 16) {
                    ForEach(filteredCategories) { category in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(category.name)
                                .font(.title2)
                                .fontWeight(.bold)
                                .padding(.horizontal)
                            
                            ForEach(category.items) { item in
                                NavigationLink(destination: MenuDetailView(menuItem: item)) {
                                    MenuItemRow(item: item)
                                }
                            }
                        }
                        .padding(.bottom, 16)
                    }
                }
                .padding(.top)
            }
        }
    }
    
    private var filteredCategories: [MenuCategory] {
        if let selectedCategory = selectedCategory {
            return viewModel.categories.filter { $0.id == selectedCategory }
        } else {
            return viewModel.categories
        }
    }
}

struct CategoryButton: View {
    let name: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(name)
                .fontWeight(isSelected ? .bold : .regular)
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .background(isSelected ? Color.blue.opacity(0.2) : Color.gray.opacity(0.1))
                .foregroundColor(isSelected ? .blue : .primary)
                .cornerRadius(20)
        }
    }
}

struct MenuItemRow: View {
    let item: MenuItem
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            if let imageUrl = item.imageUrl {
                // In a real app, we would use an image loading library here
                // For demo purposes, we'll use a placeholder
                ZStack {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 80, height: 80)
                    
                    Text("Image")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .cornerRadius(8)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(item.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                
                Text(item.formattedPrice)
                    .font(.subheadline)
                    .foregroundColor(.blue)
                
                if !item.isAvailable {
                    Text("Currently unavailable")
                        .font(.caption)
                        .foregroundColor(.red)
                }
            }
            
            Spacer()
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Color.white)
        .cornerRadius(8)
        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
        .padding(.horizontal)
    }
}
