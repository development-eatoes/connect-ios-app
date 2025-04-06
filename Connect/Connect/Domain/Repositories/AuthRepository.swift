import Foundation
import Combine

protocol AuthRepository {
    func login(phoneNumber: String) -> AnyPublisher<LoginResponse, Error>
    func verifyOTP(phoneNumber: String, sessionId: String, otp: String) -> AnyPublisher<VerifyOTPResponse, Error>
    func resendOTP(sessionId: String) -> AnyPublisher<LoginResponse, Error>
}