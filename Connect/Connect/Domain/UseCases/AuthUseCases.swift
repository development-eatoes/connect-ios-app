import Foundation
import Combine

// Login Use Case
class LoginUseCase {
    private let authRepository: AuthRepository
    
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    func execute(phoneNumber: String) -> AnyPublisher<String, Error> {
        return authRepository.login(phoneNumber: phoneNumber)
            .map { $0.sessionId }
            .eraseToAnyPublisher()
    }
}

// Verify OTP Use Case
class VerifyOTPUseCase {
    private let authRepository: AuthRepository
    
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    func execute(phoneNumber: String, sessionId: String, otp: String) -> AnyPublisher<UserSession, Error> {
        return authRepository.verifyOTP(phoneNumber: phoneNumber, sessionId: sessionId, otp: otp)
            .map { response in
                UserSession(userId: response.userId, token: response.token)
            }
            .eraseToAnyPublisher()
    }
}

// Resend OTP Use Case
class ResendOTPUseCase {
    private let authRepository: AuthRepository
    
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    func execute(sessionId: String) -> AnyPublisher<String, Error> {
        return authRepository.resendOTP(sessionId: sessionId)
            .map { $0.sessionId }
            .eraseToAnyPublisher()
    }
}