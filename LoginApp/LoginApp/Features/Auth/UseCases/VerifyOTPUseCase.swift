import Foundation
import Combine

class VerifyOTPUseCase {
    private let repository: AuthRepository
    
    init(repository: AuthRepository) {
        self.repository = repository
    }
    
    func execute(sessionId: String, otp: String) -> AnyPublisher<VerifyOTPResponse, Error> {
        return repository.verifyOTP(sessionId: sessionId, otp: otp)
            .tryMap { response in
                guard response.success, response.token != nil else {
                    throw NSError(
                        domain: "AuthError",
                        code: 2,
                        userInfo: [NSLocalizedDescriptionKey: response.message]
                    )
                }
                return response
            }
            .eraseToAnyPublisher()
    }
}
