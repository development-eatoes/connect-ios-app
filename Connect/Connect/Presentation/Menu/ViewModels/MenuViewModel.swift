import Foundation
import Combine

class MenuViewModel: ObservableObject {
    // Categories data
    @Published var categories: [MenuCategory] = []
    @Published var selectedCategoryId: String?
    
    // Menu items data
    @Published var menuItems: [MenuItem] = []
    @Published var selectedItemDetail: MenuItemDetail?
    
    // UI state
    @Published var isLoadingCategories = false
    @Published var isLoadingMenuItems = false
    @Published var isLoadingItemDetail = false
    @Published var showError = false
    @Published var errorMessage = ""
    
    // Dependencies
    private let fetchCategoriesUseCase: FetchCategoriesUseCase
    private let fetchMenuItemsUseCase: FetchMenuItemsUseCase
    private let fetchMenuItemDetailUseCase: FetchMenuItemDetailUseCase
    private var cancellables = Set<AnyCancellable>()
    
    init(
        fetchCategoriesUseCase: FetchCategoriesUseCase,
        fetchMenuItemsUseCase: FetchMenuItemsUseCase,
        fetchMenuItemDetailUseCase: FetchMenuItemDetailUseCase
    ) {
        self.fetchCategoriesUseCase = fetchCategoriesUseCase
        self.fetchMenuItemsUseCase = fetchMenuItemsUseCase
        self.fetchMenuItemDetailUseCase = fetchMenuItemDetailUseCase
    }
    
    // Load menu categories
    func loadCategories() {
        isLoadingCategories = true
        
        fetchCategoriesUseCase.execute()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoadingCategories = false
                    
                    if case .failure(let error) = completion {
                        self?.showError = true
                        self?.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] categories in
                    self?.categories = categories
                    
                    // Select the first category by default if available
                    if let firstCategoryId = categories.first?.id {
                        self?.selectCategory(categoryId: firstCategoryId)
                    }
                }
            )
            .store(in: &cancellables)
    }
    
    // Select a category and load its menu items
    func selectCategory(categoryId: String) {
        guard categoryId != selectedCategoryId else { return }
        
        selectedCategoryId = categoryId
        loadMenuItems(for: categoryId)
    }
    
    // Load menu items for the selected category
    private func loadMenuItems(for categoryId: String) {
        isLoadingMenuItems = true
        menuItems = []
        
        fetchMenuItemsUseCase.execute(categoryId: categoryId)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoadingMenuItems = false
                    
                    if case .failure(let error) = completion {
                        self?.showError = true
                        self?.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] items in
                    self?.menuItems = items
                }
            )
            .store(in: &cancellables)
    }
    
    // Select an item and load its details
    func selectItem(itemId: String) {
        isLoadingItemDetail = true
        
        fetchMenuItemDetailUseCase.execute(itemId: itemId)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoadingItemDetail = false
                    
                    if case .failure(let error) = completion {
                        self?.showError = true
                        self?.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] itemDetail in
                    self?.selectedItemDetail = itemDetail
                }
            )
            .store(in: &cancellables)
    }
    
    // Reset view model state
    func resetState() {
        categories = []
        selectedCategoryId = nil
        menuItems = []
        selectedItemDetail = nil
        isLoadingCategories = false
        isLoadingMenuItems = false
        isLoadingItemDetail = false
        showError = false
        errorMessage = ""
    }
}

#if DEBUG
class FetchCategoriesUseCase {
    private let menuRepository: MenuRepository
    
    init(menuRepository: MenuRepository) {
        self.menuRepository = menuRepository
    }
    
    func execute() -> AnyPublisher<[MenuCategory], Error> {
        return menuRepository.fetchCategories()
    }
}

class FetchMenuItemsUseCase {
    private let menuRepository: MenuRepository
    
    init(menuRepository: MenuRepository) {
        self.menuRepository = menuRepository
    }
    
    func execute(categoryId: String) -> AnyPublisher<[MenuItem], Error> {
        return menuRepository.fetchMenuItems(categoryId: categoryId)
    }
}

class FetchMenuItemDetailUseCase {
    private let menuRepository: MenuRepository
    
    init(menuRepository: MenuRepository) {
        self.menuRepository = menuRepository
    }
    
    func execute(itemId: String) -> AnyPublisher<MenuItemDetail, Error> {
        return menuRepository.fetchMenuItemDetail(itemId: itemId)
    }
}
#endif