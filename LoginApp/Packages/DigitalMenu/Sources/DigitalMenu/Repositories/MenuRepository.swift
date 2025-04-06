import Foundation
import Combine
import NetworkLayer

public class MenuRepository {
    private let networkService: NetworkService
    
    public init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    public func fetchMenu() -> AnyPublisher<[MenuItem], Error> {
        let endpoint = ApiEndpoint(
            path: "/menu",
            method: .get
        )
        
        return networkService.request(endpoint)
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
    
    public func getMenuItemDetails(id: String) -> AnyPublisher<MenuItem, Error> {
        let endpoint = ApiEndpoint(
            path: "/menu/\(id)",
            method: .get
        )
        
        return networkService.request(endpoint)
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
}
