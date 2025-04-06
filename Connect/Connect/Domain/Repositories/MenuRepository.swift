import Foundation
import Combine

protocol MenuRepository {
    func fetchCategories() -> AnyPublisher<[MenuCategory], Error>
    func fetchMenuItems(categoryId: String) -> AnyPublisher<[MenuItem], Error>
    func fetchMenuItemDetail(itemId: String) -> AnyPublisher<MenuItemDetail, Error>
    func toggleFavorite(itemId: String, isFavorite: Bool) -> AnyPublisher<Bool, Error>
}