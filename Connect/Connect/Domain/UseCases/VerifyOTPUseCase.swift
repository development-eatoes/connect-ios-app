import Foundation
import Combine

class VerifyOTPUseCase {
    private let authRepository: AuthRepository
    
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    func execute(phoneNumber: String, sessionId: String, otp: String) -> AnyPublisher<VerifyOTPResponse, Error> {
        return authRepository.verifyOTP(phoneNumber: phoneNumber, sessionId: sessionId, otp: otp)
            .eraseToAnyPublisher()
    }
}