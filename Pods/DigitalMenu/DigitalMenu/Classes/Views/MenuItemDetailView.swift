import SwiftUI
import UIComponents
import Combine
import NetworkLayer

public struct MenuItemDetailView: View {
    @StateObject private var viewModel: MenuItemDetailViewModel
    
    public init(viewModel: MenuItemDetailViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Item image
                RemoteImage(urlString: viewModel.item.imageURL, contentMode: .fill)
                    .frame(maxWidth: .infinity)
                    .frame(height: 250)
                
                VStack(alignment: .leading, spacing: 16) {
                    // Title and indicators
                    HStack {
                        Text(viewModel.item.name)
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        VegNonVegIndicator(isVegetarian: viewModel.item.isVegetarian, size: 24)
                    }
                    
                    // Price
                    Text("$\(String(format: "%.2f", viewModel.item.price))")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                    
                    // Description
                    Text("Description")
                        .font(.headline)
                    
                    Text(viewModel.item.description)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .padding(.bottom)
                    
                    // Nutrition info if available
                    if let nutrition = viewModel.item.nutritionInfo {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Nutrition Information")
                                .font(.headline)
                            
                            HStack(spacing: 16) {
                                NutritionInfoItem(label: "Calories", value: "\(nutrition.calories)")
                                NutritionInfoItem(label: "Protein", value: nutrition.protein)
                                NutritionInfoItem(label: "Carbs", value: nutrition.carbs)
                                NutritionInfoItem(label: "Fat", value: nutrition.fat)
                            }
                        }
                    }
                    
                    Spacer()
                    
                    // Add to order button
                    PrimaryButton(title: "Add to Order") {
                        viewModel.addToOrder()
                    }
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadItemDetails()
        }
    }
}

private struct NutritionInfoItem: View {
    let label: String
    let value: String
    
    var body: some View {
        VStack(alignment: .center) {
            Text(value)
                .font(.headline)
                .foregroundColor(.primary)
            
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(minWidth: 60)
    }
}

public class MenuItemDetailViewModel: ObservableObject {
    @Published public var item: MenuItem
    @Published public var isLoading: Bool = false
    @Published public var errorMessage: String?
    
    private let menuService: MenuServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    public init(item: MenuItem, menuService: MenuServiceProtocol) {
        self.item = item
        self.menuService = menuService
    }
    
    public func loadItemDetails() async {
        // In a real app, we would refresh the details from the API here
        // For now, we'll just use what we already have
    }
    
    public func addToOrder() {
        // In a real app, this would add the item to a cart or order
        print("Adding \(item.name) to order")
    }
}

// Preview Helpers
struct MenuItemDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = MenuItemDetailViewModel(
            item: MenuItem.sample,
            menuService: MockMenuService()
        )
        
        return NavigationView {
            MenuItemDetailView(viewModel: viewModel)
        }
    }
}

private class MockMenuService: MenuServiceProtocol {
    func getCategories() -> AnyPublisher<MenuResponse, NetworkError> {
        return Fail(error: NetworkError.invalidResponse).eraseToAnyPublisher()
    }
    
    func getItemsByCategory(categoryId: String) -> AnyPublisher<MenuResponse, NetworkError> {
        return Fail(error: NetworkError.invalidResponse).eraseToAnyPublisher()
    }
    
    func getItemDetails(itemId: String) -> AnyPublisher<MenuItemResponse, NetworkError> {
        return Fail(error: NetworkError.invalidResponse).eraseToAnyPublisher()
    }
}