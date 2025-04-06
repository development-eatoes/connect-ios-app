import Foundation
import Combine

class LoginUseCase {
    private let repository: AuthRepository
    
    init(repository: AuthRepository) {
        self.repository = repository
    }
    
    func execute(phoneNumber: String) -> AnyPublisher<String, Error> {
        return repository.login(phoneNumber: phoneNumber)
            .tryMap { response in
                guard response.success, let sessionId = response.sessionId else {
                    throw NSError(
                        domain: "AuthError",
                        code: 1,
                        userInfo: [NSLocalizedDescriptionKey: response.message]
                    )
                }
                return sessionId
            }
            .eraseToAnyPublisher()
    }
}
