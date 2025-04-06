import Foundation
import Combine

// Fetch Categories Use Case
class FetchCategoriesUseCase {
    private let menuRepository: MenuRepository
    
    init(menuRepository: MenuRepository) {
        self.menuRepository = menuRepository
    }
    
    func execute() -> AnyPublisher<[MenuCategory], Error> {
        return menuRepository.fetchCategories()
            .eraseToAnyPublisher()
    }
}

// Fetch Menu Items Use Case
class FetchMenuItemsUseCase {
    private let menuRepository: MenuRepository
    
    init(menuRepository: MenuRepository) {
        self.menuRepository = menuRepository
    }
    
    func execute(category: String) -> AnyPublisher<[MenuItem], Error> {
        return menuRepository.fetchMenuItems(for: category)
            .eraseToAnyPublisher()
    }
}

// Fetch Menu Item Detail Use Case
class FetchMenuItemDetailUseCase {
    private let menuRepository: MenuRepository
    
    init(menuRepository: MenuRepository) {
        self.menuRepository = menuRepository
    }
    
    func execute(id: String) -> AnyPublisher<MenuItem, Error> {
        return menuRepository.fetchMenuItem(id: id)
            .eraseToAnyPublisher()
    }
}