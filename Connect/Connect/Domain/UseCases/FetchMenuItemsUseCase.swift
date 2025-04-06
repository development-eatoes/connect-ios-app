import Foundation
import Combine

class FetchMenuItemsUseCase {
    private let menuRepository: MenuRepository
    
    init(menuRepository: MenuRepository) {
        self.menuRepository = menuRepository
    }
    
    func execute(categoryId: String) -> AnyPublisher<[MenuItem], Error> {
        return menuRepository.fetchMenuItems(categoryId: categoryId)
            .eraseToAnyPublisher()
    }
}