import SwiftUI
import UIComponents
import Combine

public struct MenuHomeView: View {
    @StateObject private var viewModel: MenuHomeViewModel
    
    public init(viewModel: MenuHomeViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    public var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Header
                    Text("Categories")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                    
                    // Grid of categories
                    LazyVGrid(columns: [
                        GridItem(.flexible(), spacing: 16),
                        GridItem(.flexible(), spacing: 16)
                    ], spacing: 16) {
                        ForEach(viewModel.categories) { category in
                            NavigationLink(destination: 
                                viewModel.categoryView(for: category.id)
                            ) {
                                CategoryCard(category: category)
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
                await viewModel.loadCategories()
            }
        }
    }
}

private struct CategoryCard: View {
    let category: MenuCategory
    
    var body: some View {
        VStack(alignment: .leading) {
            if let imageURL = category.imageURL {
                RemoteImage(urlString: imageURL, contentMode: .fill)
                    .frame(height: 120)
                    .cornerRadius(8)
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.1))
                    .frame(height: 120)
                    .cornerRadius(8)
            }
            
            Text(category.name)
                .font(.headline)
                .padding(.vertical, 4)
            
            if let description = category.description {
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
        }
    }
}

public class MenuHomeViewModel: ObservableObject {
    @Published public var categories: [MenuCategory] = []
    @Published public var isLoading: Bool = false
    @Published public var errorMessage: String?
    
    private let menuService: MenuServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    public init(menuService: MenuServiceProtocol) {
        self.menuService = menuService
    }
    
    public func loadCategories() async {
        DispatchQueue.main.async {
            self.isLoading = true
            self.errorMessage = nil
        }
        
        menuService.getCategories()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                self.isLoading = false
                if case .failure(let error) = completion {
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { response in
                if let categories = response.categories {
                    self.categories = categories.map { MenuCategory(from: $0) }
                }
            }
            .store(in: &cancellables)
    }
    
    public func categoryView(for categoryId: String) -> some View {
        let viewModel = MenuCategoryViewModel(
            categoryId: categoryId,
            menuService: menuService
        )
        return MenuCategoryView(viewModel: viewModel)
    }
}

// Preview Helpers
struct MenuHomeView_Previews: PreviewProvider {
    static var previews: some View {
        let mockViewModel = MenuHomeViewModel(menuService: MockMenuService())
        mockViewModel.categories = MenuCategory.samples
        
        return MenuHomeView(viewModel: mockViewModel)
    }
}

private class MockMenuService: MenuServiceProtocol {
    func getCategories() -> AnyPublisher<MenuResponse, NetworkError> {
        return Just(MenuResponse(success: true, categories: 
            MenuCategory.samples.map { category in
                NetworkLayer.MenuCategory(
                    id: category.id,
                    name: category.name,
                    description: category.description,
                    imageURL: category.imageURL
                )
            }
        ))
        .setFailureType(to: NetworkError.self)
        .eraseToAnyPublisher()
    }
    
    func getItemsByCategory(categoryId: String) -> AnyPublisher<MenuResponse, NetworkError> {
        return Just(MenuResponse(success: true))
            .setFailureType(to: NetworkError.self)
            .eraseToAnyPublisher()
    }
    
    func getItemDetails(itemId: String) -> AnyPublisher<MenuItemResponse, NetworkError> {
        return Fail(error: NetworkError.invalidResponse)
            .eraseToAnyPublisher()
    }
}