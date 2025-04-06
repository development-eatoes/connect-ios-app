import Foundation

// MARK: - Login Response
struct LoginResponse: Codable {
    let sessionId: String
    let expiresIn: Int
}

// MARK: - OTP Verification Response
struct TokenResponse: Codable {
    let token: String
    let refreshToken: String
    let expiresIn: Int
}

// MARK: - Resend OTP Response
struct ResendOTPResponse: Codable {
    let success: Bool
    let sessionId: String?
    let expiresIn: Int
}

// MARK: - Error Responses
struct ApiErrorResponse: Codable {
    let error: String
    let message: String
    let statusCode: Int
}

// MARK: - Auth Repository Protocol
protocol AuthRepository {
    func login(phoneNumber: String) -> AnyPublisher<LoginResponse, Error>
    func verifyOTP(sessionId: String, phoneNumber: String, otp: String) -> AnyPublisher<TokenResponse, Error>
    func resendOTP(sessionId: String, phoneNumber: String) -> AnyPublisher<ResendOTPResponse, Error>
}

// MARK: - Custom Errors
enum AuthError: Error, LocalizedError {
    case invalidPhoneNumber
    case invalidOTP
    case sessionExpired
    case networkError
    case serverError(String)
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .invalidPhoneNumber:
            return "Please enter a valid phone number"
        case .invalidOTP:
            return "The OTP you entered is incorrect"
        case .sessionExpired:
            return "Your session has expired. Please try again"
        case .networkError:
            return "Network error. Please check your internet connection"
        case .serverError(let message):
            return message
        case .unknown:
            return "An unexpected error occurred"
        }
    }
}