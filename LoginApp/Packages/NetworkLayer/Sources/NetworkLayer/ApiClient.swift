import Foundation
import Combine

public protocol ApiClientProtocol {
    func execute<T: Decodable>(_ endpoint: ApiEndpoint) -> AnyPublisher<T, NetworkError>
}

public class ApiClient: ApiClientProtocol {
    private let networkService: NetworkService
    
    public init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    public func execute<T: Decodable>(_ endpoint: ApiEndpoint) -> AnyPublisher<T, NetworkError> {
        return networkService.request(endpoint)
    }
}
