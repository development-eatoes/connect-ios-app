import Foundation
import Combine

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