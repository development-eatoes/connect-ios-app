import Foundation
import Combine
import NetworkLayer

protocol AuthRepository {
    func login(phoneNumber: String) -> AnyPublisher<LoginResponse, Error>
    func verifyOTP(sessionId: String, otp: String) -> AnyPublisher<VerifyOTPResponse, Error>
    func resendOTP(sessionId: String) -> AnyPublisher<LoginResponse, Error>
}
