import Foundation
import Combine

class AuthRepositoryImpl: AuthRepository {
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func login(phoneNumber: String) -> AnyPublisher<LoginResponse, Error> {
        let endpoint = ApiEndpoint(
            path: "/auth/login",
            method: .post,
            body: ["phoneNumber": phoneNumber]
        )
        
        return networkService.request(endpoint)
    }
    
    func verifyOTP(phoneNumber: String, sessionId: String, otp: String) -> AnyPublisher<VerifyOTPResponse, Error> {
        let endpoint = ApiEndpoint(
            path: "/auth/verify-otp",
            method: .post,
            body: [
                "phoneNumber": phoneNumber,
                "sessionId": sessionId,
                "otp": otp
            ]
        )
        
        return networkService.request(endpoint)
    }
    
    func resendOTP(sessionId: String) -> AnyPublisher<LoginResponse, Error> {
        let endpoint = ApiEndpoint(
            path: "/auth/resend-otp",
            method: .post,
            body: ["sessionId": sessionId]
        )
        
        return networkService.request(endpoint)
    }
}