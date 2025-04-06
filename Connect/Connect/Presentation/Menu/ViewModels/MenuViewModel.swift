import Foundation
import Combine

class MenuViewModel: ObservableObject {
    // Categories
    @Published var categories: [MenuCategory] = []
    @Published var isLoadingCategories: Bool = false
    
    // Menu items for a selected category
    @Published var selectedCategoryId: String? = nil
    @Published var menuItems: [MenuItem] = []
    @Published var isLoadingMenuItems: Bool = false
    
    // Item details
    @Published var selectedItemId: String? = nil
    @Published var selectedItemDetail: MenuItemDetail? = nil
    @Published var isLoadingItemDetail: Bool = false
    
    // Error handling
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
    
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
    
    func loadCategories() {
        isLoadingCategories = true
        showError = false
        
        fetchCategoriesUseCase.execute()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    guard let self = self else { return }
                    self.isLoadingCategories = false
                    
                    if case .failure(let error) = completion {
                        self.showError = true
                        self.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] categories in
                    guard let self = self else { return }
                    self.categories = categories
                    
                    // If no category is selected and we have categories, select the first one
                    if self.selectedCategoryId == nil, let firstCategory = categories.first {
                        self.selectCategory(categoryId: firstCategory.id)
                    }
                }
            )
            .store(in: &cancellables)
    }
    
    func selectCategory(categoryId: String) {
        guard selectedCategoryId != categoryId else { return }
        
        selectedCategoryId = categoryId
        loadMenuItems(categoryId: categoryId)
    }
    
    func loadMenuItems(categoryId: String) {
        isLoadingMenuItems = true
        showError = false
        
        fetchMenuItemsUseCase.execute(categoryId: categoryId)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    guard let self = self else { return }
                    self.isLoadingMenuItems = false
                    
                    if case .failure(let error) = completion {
                        self.showError = true
                        self.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] items in
                    guard let self = self else { return }
                    self.menuItems = items
                }
            )
            .store(in: &cancellables)
    }
    
    func selectItem(itemId: String) {
        guard selectedItemId != itemId else { return }
        
        selectedItemId = itemId
        loadItemDetail(itemId: itemId)
    }
    
    func loadItemDetail(itemId: String) {
        isLoadingItemDetail = true
        showError = false
        selectedItemDetail = nil
        
        fetchMenuItemDetailUseCase.execute(itemId: itemId)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    guard let self = self else { return }
                    self.isLoadingItemDetail = false
                    
                    if case .failure(let error) = completion {
                        self.showError = true
                        self.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] itemDetail in
                    guard let self = self else { return }
                    self.selectedItemDetail = itemDetail
                }
            )
            .store(in: &cancellables)
    }
    
    func refreshData() {
        loadCategories()
        
        if let categoryId = selectedCategoryId {
            loadMenuItems(categoryId: categoryId)
        }
        
        if let itemId = selectedItemId {
            loadItemDetail(itemId: itemId)
        }
    }
}