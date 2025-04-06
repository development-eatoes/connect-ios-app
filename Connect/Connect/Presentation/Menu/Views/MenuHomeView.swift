import SwiftUI

struct MenuHomeView: View {
    @ObservedObject var viewModel: MenuViewModel
    @EnvironmentObject private var appCoordinator: AppCoordinator
    @State private var showingItemDetail = false
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack(spacing: 0) {
                    // Header
                    headerView
                    
                    // Main Content
                    ScrollView {
                        VStack(spacing: 24) {
                            // Categories section
                            categoriesSection
                            
                            // Items section
                            itemsSection
                        }
                        .padding(.horizontal)
                    }
                }
                
                // Error handling
                if viewModel.showError {
                    ErrorView(message: viewModel.errorMessage) {
                        viewModel.showError = false
                    }
                }
                
                // Loading screen
                if viewModel.isLoadingCategories {
                    LoadingView()
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                // Load data when the view appears
                viewModel.loadCategories()
            }
            .sheet(isPresented: $showingItemDetail) {
                if let itemDetail = viewModel.selectedItemDetail {
                    MenuItemDetailView(itemDetail: itemDetail)
                }
            }
        }
    }
    
    // Header view with profile and logout
    private var headerView: some View {
        VStack(spacing: 0) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Connect Menu")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Explore categories")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Button(action: {
                    appCoordinator.logout()
                }) {
                    Text("Logout")
                        .font(.subheadline)
                        .foregroundColor(.red)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.red, lineWidth: 1)
                        )
                }
            }
            .padding()
            
            Divider()
        }
        .background(Color(.systemBackground))
    }
    
    // Categories horizontal scroll section
    private var categoriesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Categories")
                .font(.headline)
                .padding(.top, 8)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(viewModel.categories) { category in
                        CategoryCardView(
                            category: category,
                            isSelected: category.id == viewModel.selectedCategoryId
                        )
                        .onTapGesture {
                            viewModel.selectCategory(categoryId: category.id)
                        }
                    }
                }
                .padding(.vertical, 4)
            }
        }
    }
    
    // Menu items section
    private var itemsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            if let selectedCategory = viewModel.categories.first(where: { $0.id == viewModel.selectedCategoryId }) {
                HStack {
                    Text(selectedCategory.name)
                        .font(.headline)
                    
                    Spacer()
                    
                    Text("\(viewModel.menuItems.count) items")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(.top, 8)
            }
            
            if viewModel.isLoadingMenuItems {
                HStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
                .padding()
            } else if viewModel.menuItems.isEmpty {
                Text("No items found in this category")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
            } else {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    ForEach(viewModel.menuItems) { item in
                        MenuItemCardView(item: item)
                            .onTapGesture {
                                viewModel.selectItem(itemId: item.id)
                                showingItemDetail = true
                            }
                    }
                }
            }
        }
    }
}

// Category card view
struct CategoryCardView: View {
    let category: MenuCategory
    let isSelected: Bool
    
    var body: some View {
        VStack {
            // This is a placeholder for the image
            // In a real app, use AsyncImage or SDWebImageSwiftUI
            ZStack {
                Circle()
                    .fill(isSelected ? Color.blue.opacity(0.1) : Color.gray.opacity(0.1))
                    .frame(width: 70, height: 70)
                
                Image(systemName: "fork.knife")
                    .font(.system(size: 24))
                    .foregroundColor(isSelected ? .blue : .gray)
            }
            
            Text(category.name)
                .font(.caption)
                .fontWeight(isSelected ? .bold : .regular)
                .foregroundColor(isSelected ? .primary : .gray)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .frame(width: 80)
        }
        .padding(.vertical, 4)
    }
}

// Menu item card view
struct MenuItemCardView: View {
    let item: MenuItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // This is a placeholder for the image
            // In a real app, use AsyncImage or SDWebImageSwiftUI
            Rectangle()
                .fill(Color.gray.opacity(0.2))
                .aspectRatio(1.3, contentMode: .fit)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    Image(systemName: "photo")
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                )
            
            Text(item.name)
                .font(.headline)
                .lineLimit(1)
            
            Text(item.description)
                .font(.caption)
                .foregroundColor(.gray)
                .lineLimit(2)
            
            Text("$\(String(format: "%.2f", item.price))")
                .font(.subheadline)
                .fontWeight(.bold)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        )
    }
}

#if DEBUG
struct MenuHomeView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = MenuViewModel(
            fetchCategoriesUseCase: FetchCategoriesUseCase(menuRepository: MockMenuRepository()),
            fetchMenuItemsUseCase: FetchMenuItemsUseCase(menuRepository: MockMenuRepository()),
            fetchMenuItemDetailUseCase: FetchMenuItemDetailUseCase(menuRepository: MockMenuRepository())
        )
        
        MenuHomeView(viewModel: viewModel)
            .environmentObject(AppCoordinator())
    }
}

// Mock repository for preview purposes
class MockMenuRepository: MenuRepository {
    func fetchCategories() -> AnyPublisher<[MenuCategory], Error> {
        let categories = [
            MenuCategory(id: "1", name: "Starters", image: "", itemCount: 5),
            MenuCategory(id: "2", name: "Main Course", image: "", itemCount: 8),
            MenuCategory(id: "3", name: "Desserts", image: "", itemCount: 3)
        ]
        return Just(categories)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func fetchMenuItems(categoryId: String) -> AnyPublisher<[MenuItem], Error> {
        let items = [
            MenuItem(id: "1", name: "Caesar Salad", description: "Fresh romaine lettuce with creamy dressing", image: "", price: 8.99, categoryId: "1"),
            MenuItem(id: "2", name: "Fried Calamari", description: "Crispy squid rings with dipping sauce", image: "", price: 9.99, categoryId: "1")
        ]
        return Just(items)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func fetchMenuItemDetail(itemId: String) -> AnyPublisher<MenuItemDetail, Error> {
        let detail = MenuItemDetail(
            id: "1",
            name: "Caesar Salad",
            description: "Fresh romaine lettuce with creamy dressing",
            image: "",
            price: 8.99,
            categoryId: "1",
            ingredients: ["Romaine lettuce", "Parmesan cheese", "Croutons", "Caesar dressing"],
            nutritionalInfo: NutritionalInfo(calories: 320, protein: 7.5, carbs: 12.0, fat: 28.0, sugar: 2.5, sodium: 720.0),
            allergens: ["Dairy", "Gluten"],
            preparationTime: 10,
            isFavorite: false
        )
        return Just(detail)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func toggleFavorite(itemId: String, isFavorite: Bool) -> AnyPublisher<Bool, Error> {
        return Just(true)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
#endif