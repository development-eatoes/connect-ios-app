import Foundation

// Request Models
public struct LoginRequest: Codable {
    public let phoneNumber: String
    
    public init(phoneNumber: String) {
        self.phoneNumber = phoneNumber
    }
}

public struct VerifyOTPRequest: Codable {
    public let phoneNumber: String
    public let otp: String
    
    public init(phoneNumber: String, otp: String) {
        self.phoneNumber = phoneNumber
        self.otp = otp
    }
}

// Response Models
public struct LoginResponse: Codable {
    public let success: Bool
    public let message: String
    public let requestId: String?
    
    public init(success: Bool, message: String, requestId: String?) {
        self.success = success
        self.message = message
        self.requestId = requestId
    }
}

public struct VerifyOTPResponse: Codable {
    public let success: Bool
    public let message: String
    public let token: String?
    public let user: User?
    
    public init(success: Bool, message: String, token: String?, user: User?) {
        self.success = success
        self.message = message
        self.token = token
        self.user = user
    }
}

public struct User: Codable {
    public let id: String
    public let phoneNumber: String
    public let name: String?
    public let email: String?
    
    public init(id: String, phoneNumber: String, name: String?, email: String?) {
        self.id = id
        self.phoneNumber = phoneNumber
        self.name = name
        self.email = email
    }
}