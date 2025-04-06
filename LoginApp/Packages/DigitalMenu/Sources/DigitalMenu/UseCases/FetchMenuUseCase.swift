import Foundation
import Combine

public class FetchMenuUseCase {
    private let repository: MenuRepository
    
    public init(repository: MenuRepository) {
        self.repository = repository
    }
    
    public func execute() -> AnyPublisher<[MenuItem], Error> {
        return repository.fetchMenu()
    }
}
