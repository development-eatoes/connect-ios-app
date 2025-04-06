import Foundation

// MARK: - Auth Requests
struct LoginRequest: Encodable {
    let phoneNumber: String
}

struct VerifyOTPRequest: Encodable {
    let phoneNumber: String
    let sessionId: String
    let otp: String
}

struct ResendOTPRequest: Encodable {
    let sessionId: String
}

// MARK: - Auth Responses
struct LoginResponse: Decodable {
    let sessionId: String
    let expiresInSeconds: Int
}

struct VerifyOTPResponse: Decodable {
    let token: String
    let expiresInSeconds: Int
    let user: User
}

// MARK: - User
struct User: Codable {
    let id: String
    let phoneNumber: String
    let name: String?
    let email: String?
}