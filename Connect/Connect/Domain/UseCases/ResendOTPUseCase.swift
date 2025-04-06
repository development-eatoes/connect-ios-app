import Foundation
import Combine

class ResendOTPUseCase {
    private let authRepository: AuthRepository
    
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    func execute(sessionId: String) -> AnyPublisher<LoginResponse, Error> {
        return authRepository.resendOTP(sessionId: sessionId)
            .eraseToAnyPublisher()
    }
}