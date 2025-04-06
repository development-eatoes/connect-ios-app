import Foundation
import Combine

public protocol AuthServiceProtocol {
    func login(phoneNumber: String) -> AnyPublisher<LoginResponse, NetworkError>
    func verifyOTP(phoneNumber: String, otp: String) -> AnyPublisher<VerifyOTPResponse, NetworkError>
}

public class AuthService: AuthServiceProtocol {
    private let networkService: NetworkServiceProtocol
    
    public init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    public func login(phoneNumber: String) -> AnyPublisher<LoginResponse, NetworkError> {
        let request = LoginRequest(phoneNumber: phoneNumber)
        let parameters: [String: Any] = [
            "phoneNumber": request.phoneNumber
        ]
        
        return networkService.fetch(from: "/auth/login", method: .post, parameters: parameters)
    }
    
    public func verifyOTP(phoneNumber: String, otp: String) -> AnyPublisher<VerifyOTPResponse, NetworkError> {
        let request = VerifyOTPRequest(phoneNumber: phoneNumber, otp: otp)
        let parameters: [String: Any] = [
            "phoneNumber": request.phoneNumber,
            "otp": request.otp
        ]
        
        return networkService.fetch(from: "/auth/verify-otp", method: .post, parameters: parameters)
    }
}