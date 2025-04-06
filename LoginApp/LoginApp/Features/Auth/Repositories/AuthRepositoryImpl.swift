import Foundation
import Combine
import NetworkLayer

class AuthRepositoryImpl: AuthRepository {
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func login(phoneNumber: String) -> AnyPublisher<LoginResponse, Error> {
        let endpoint = ApiEndpoint(
            path: "/auth/login",
            method: .post,
            body: ["phone_number": phoneNumber]
        )
        
        return networkService.request(endpoint)
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
    
    func verifyOTP(sessionId: String, otp: String) -> AnyPublisher<VerifyOTPResponse, Error> {
        let endpoint = ApiEndpoint(
            path: "/auth/verify",
            method: .post,
            body: [
                "session_id": sessionId,
                "otp": otp
            ]
        )
        
        return networkService.request(endpoint)
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
    
    func resendOTP(sessionId: String) -> AnyPublisher<LoginResponse, Error> {
        let endpoint = ApiEndpoint(
            path: "/auth/resend",
            method: .post,
            body: ["session_id": sessionId]
        )
        
        return networkService.request(endpoint)
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
}
