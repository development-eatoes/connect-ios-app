import Foundation
import Combine

// MARK: - Auth Repository Implementation
class AuthRepositoryImpl: AuthRepository {
    private let networkService: NetworkServiceProtocol
    private let baseURL: URL
    
    init(networkService: NetworkServiceProtocol, baseURL: URL) {
        self.networkService = networkService
        self.baseURL = baseURL
    }
    
    // Login with phone number
    func login(phoneNumber: String) -> AnyPublisher<LoginResponse, Error> {
        let endpoint = Endpoint(
            path: "/auth/login",
            method: .post,
            body: ["phoneNumber": phoneNumber]
        )
        
        return networkService.request(endpoint: endpoint)
    }
    
    // Verify OTP
    func verifyOTP(sessionId: String, phoneNumber: String, otp: String) -> AnyPublisher<TokenResponse, Error> {
        let endpoint = Endpoint(
            path: "/auth/verify-otp",
            method: .post,
            body: [
                "sessionId": sessionId,
                "phoneNumber": phoneNumber,
                "otp": otp
            ]
        )
        
        return networkService.request(endpoint: endpoint)
    }
    
    // Resend OTP
    func resendOTP(sessionId: String, phoneNumber: String) -> AnyPublisher<ResendOTPResponse, Error> {
        let endpoint = Endpoint(
            path: "/auth/resend-otp",
            method: .post,
            body: [
                "sessionId": sessionId,
                "phoneNumber": phoneNumber
            ]
        )
        
        return networkService.request(endpoint: endpoint)
    }
}

// MARK: - Mock Auth Repository for Development/Testing
#if DEBUG
class MockAuthRepositoryWithDelay: AuthRepository {
    private let delay: TimeInterval
    
    init(delay: TimeInterval = 1.0) {
        self.delay = delay
    }
    
    func login(phoneNumber: String) -> AnyPublisher<LoginResponse, Error> {
        return Just(LoginResponse(sessionId: "mock-session-id-\(UUID().uuidString)", expiresIn: 300))
            .delay(for: .seconds(delay), scheduler: RunLoop.main)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func verifyOTP(sessionId: String, phoneNumber: String, otp: String) -> AnyPublisher<TokenResponse, Error> {
        if otp == "000000" { // Simulate bad OTP
            return Fail(error: AuthError.invalidOTP)
                .delay(for: .seconds(delay), scheduler: RunLoop.main)
                .eraseToAnyPublisher()
        }
        
        return Just(TokenResponse(token: "mock-token-\(UUID().uuidString)", refreshToken: "mock-refresh-\(UUID().uuidString)", expiresIn: 3600))
            .delay(for: .seconds(delay), scheduler: RunLoop.main)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func resendOTP(sessionId: String, phoneNumber: String) -> AnyPublisher<ResendOTPResponse, Error> {
        return Just(ResendOTPResponse(success: true, sessionId: "mock-session-id-\(UUID().uuidString)", expiresIn: 300))
            .delay(for: .seconds(delay), scheduler: RunLoop.main)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
#endif