import Foundation
import Combine

class MenuRepositoryImpl: MenuRepository {
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func fetchCategories() -> AnyPublisher<[MenuCategory], Error> {
        let endpoint = ApiEndpoint(path: "/menu/categories")
        return networkService.request(endpoint)
    }
    
    func fetchMenuItems(categoryId: String) -> AnyPublisher<[MenuItem], Error> {
        let endpoint = ApiEndpoint(
            path: "/menu/items",
            queryItems: [URLQueryItem(name: "categoryId", value: categoryId)]
        )
        return networkService.request(endpoint)
    }
    
    func fetchMenuItemDetail(itemId: String) -> AnyPublisher<MenuItemDetail, Error> {
        let endpoint = ApiEndpoint(path: "/menu/items/\(itemId)")
        return networkService.request(endpoint)
    }
    
    func toggleFavorite(itemId: String, isFavorite: Bool) -> AnyPublisher<Bool, Error> {
        let endpoint = ApiEndpoint(
            path: "/menu/items/\(itemId)/favorite",
            method: .post,
            body: ["isFavorite": isFavorite]
        )
        
        return networkService.request(endpoint)
    }
}