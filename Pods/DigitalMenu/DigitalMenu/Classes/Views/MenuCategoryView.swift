import SwiftUI
import UIComponents
import Combine
import NetworkLayer

public struct MenuCategoryView: View {
    @StateObject private var viewModel: MenuCategoryViewModel
    
    public init(viewModel: MenuCategoryViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Category header
                if let category = viewModel.category {
                    Text(category.name)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                }
                
                // Menu items
                LazyVStack(spacing: 16) {
                    ForEach(viewModel.menuItems) { item in
                        NavigationLink(destination: 
                            viewModel.itemDetailView(for: item)
                        ) {
                            MenuItemRow(item: item)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadCategory()
            await viewModel.loadMenuItems()
        }
    }
}

private struct MenuItemRow: View {
    let item: MenuItem
    
    var body: some View {
        HStack(spacing: 16) {
            // Image
            RemoteImage(urlString: item.imageURL, contentMode: .fill)
                .frame(width: 80, height: 80)
                .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 4) {
                // Name and veg/non-veg indicator
                HStack {
                    Text(item.name)
                        .font(.headline)
                    
                    Spacer()
                    
                    VegNonVegIndicator(isVegetarian: item.isVegetarian)
                }
                
                // Description
                Text(item.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                
                // Price
                Text("$\(String(format: "%.2f", item.price))")
                    .font(.headline)
                    .foregroundColor(.primary)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

public class MenuCategoryViewModel: ObservableObject {
    private let categoryId: String
    private let menuService: MenuServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    @Published public var category: MenuCategory?
    @Published public var menuItems: [MenuItem] = []
    @Published public var isLoading: Bool = false
    @Published public var errorMessage: String?
    
    public init(categoryId: String, menuService: MenuServiceProtocol) {
        self.categoryId = categoryId
        self.menuService = menuService
    }
    
    public func loadCategory() async {
        // This would load the category details, but for now we'll just create one
        // In a real app, this would fetch from an API using menuService
        self.category = MenuCategory(id: categoryId, name: categoryName(for: categoryId))
    }
    
    public func loadMenuItems() async {
        DispatchQueue.main.async {
            self.isLoading = true
            self.errorMessage = nil
        }
        
        menuService.getItemsByCategory(categoryId: categoryId)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                self.isLoading = false
                if case .failure(let error) = completion {
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { response in
                if let items = response.items {
                    self.menuItems = items.map { MenuItem(from: $0) }
                }
            }
            .store(in: &cancellables)
    }
    
    public func itemDetailView(for item: MenuItem) -> some View {
        let viewModel = MenuItemDetailViewModel(
            item: item,
            menuService: menuService
        )
        return MenuItemDetailView(viewModel: viewModel)
    }
    
    private func categoryName(for categoryId: String) -> String {
        switch categoryId {
        case "pizza": return "Pizza"
        case "pasta": return "Pasta"
        case "desserts": return "Desserts"
        default: return "Menu Items"
        }
    }
}

// Preview Helpers
struct MenuCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        let mockViewModel = MenuCategoryViewModel(
            categoryId: "pizza",
            menuService: MockMenuService()
        )
        mockViewModel.category = MenuCategory(id: "pizza", name: "Pizza", description: "Delicious pizzas")
        mockViewModel.menuItems = [MenuItem.sample]
        
        return NavigationView {
            MenuCategoryView(viewModel: mockViewModel)
        }
    }
}

private class MockMenuService: MenuServiceProtocol {
    func getCategories() -> AnyPublisher<MenuResponse, NetworkError> {
        return Fail(error: NetworkError.invalidResponse).eraseToAnyPublisher()
    }
    
    func getItemsByCategory(categoryId: String) -> AnyPublisher<MenuResponse, NetworkError> {
        return Just(MenuResponse(
            success: true,
            items: [
                MenuItemResponse(
                    id: "1",
                    name: "Margherita Pizza",
                    description: "Classic Italian pizza with fresh tomato sauce, mozzarella, and basil leaves",
                    price: 12.99,
                    imageURL: "https://images.unsplash.com/photo-1513104890138-7c749659a591",
                    isVegetarian: true,
                    categoryId: "pizza",
                    nutritionInfo: NutritionInfo(
                        calories: 820,
                        protein: "24g",
                        carbs: "87g",
                        fat: "32g"
                    )
                )
            ]
        ))
        .setFailureType(to: NetworkError.self)
        .eraseToAnyPublisher()
    }
    
    func getItemDetails(itemId: String) -> AnyPublisher<MenuItemResponse, NetworkError> {
        return Fail(error: NetworkError.invalidResponse).eraseToAnyPublisher()
    }
}