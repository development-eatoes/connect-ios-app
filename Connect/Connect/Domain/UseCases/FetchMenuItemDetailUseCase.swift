import Foundation
import Combine

class FetchMenuItemDetailUseCase {
    private let menuRepository: MenuRepository
    
    init(menuRepository: MenuRepository) {
        self.menuRepository = menuRepository
    }
    
    func execute(itemId: String) -> AnyPublisher<MenuItemDetail, Error> {
        return menuRepository.fetchMenuItemDetail(itemId: itemId)
            .eraseToAnyPublisher()
    }
}