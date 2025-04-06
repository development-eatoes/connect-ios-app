import Foundation
import Combine

class LoginUseCase {
    private let authRepository: AuthRepository
    
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    func execute(phoneNumber: String) -> AnyPublisher<String, Error> {
        return authRepository.login(phoneNumber: phoneNumber)
            .map { response -> String in
                return response.sessionId
            }
            .eraseToAnyPublisher()
    }
}