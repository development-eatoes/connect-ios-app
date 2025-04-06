import Foundation
import Combine

class ResendOTPUseCase {
    private let repository: AuthRepository
    
    init(repository: AuthRepository) {
        self.repository = repository
    }
    
    func execute(sessionId: String) -> AnyPublisher<Void, Error> {
        return repository.resendOTP(sessionId: sessionId)
            .tryMap { response in
                guard response.success else {
                    throw NSError(
                        domain: "AuthError",
                        code: 3,
                        userInfo: [NSLocalizedDescriptionKey: response.message]
                    )
                }
                return ()
            }
            .eraseToAnyPublisher()
    }
}
