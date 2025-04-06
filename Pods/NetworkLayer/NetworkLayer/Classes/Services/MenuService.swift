import Foundation
import Combine

public protocol MenuServiceProtocol {
    func getCategories() -> AnyPublisher<MenuResponse, NetworkError>
    func getItemsByCategory(categoryId: String) -> AnyPublisher<MenuResponse, NetworkError>
    func getItemDetails(itemId: String) -> AnyPublisher<MenuItemResponse, NetworkError>
}

public class MenuService: MenuServiceProtocol {
    private let networkService: NetworkServiceProtocol
    
    public init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    public func getCategories() -> AnyPublisher<MenuResponse, NetworkError> {
        return networkService.fetch(from: "/menu/categories", method: .get)
    }
    
    public func getItemsByCategory(categoryId: String) -> AnyPublisher<MenuResponse, NetworkError> {
        return networkService.fetch(from: "/menu/categories/\(categoryId)/items", method: .get)
    }
    
    public func getItemDetails(itemId: String) -> AnyPublisher<MenuItemResponse, NetworkError> {
        return networkService.fetch(from: "/menu/items/\(itemId)", method: .get)
    }
}